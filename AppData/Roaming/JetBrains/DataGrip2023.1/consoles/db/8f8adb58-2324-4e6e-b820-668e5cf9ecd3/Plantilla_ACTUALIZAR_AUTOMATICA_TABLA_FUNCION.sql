DROP TABLE IF EXISTS mas_entregadas;
CREATE TABLE mas_entregadas(
    codigo_pelicula NUMERIC(5),
    titulo VARCHAR(60),
    cantidad INTEGER
);

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_TABLA_MAS_ENTREGADAS()
    RETURNS VOID
AS $$
    BEGIN
    DELETE FROM mas_entregadas;
    INSERT INTO mas_entregadas (codigo_pelicula, titulo, cantidad)
    (SELECT p.codigo_pelicula, titulo, COUNT(*) AS cantidad FROM esq_peliculas_pelicula p
    INNER JOIN esq_peliculas_renglon_entrega r ON p.codigo_pelicula=r.codigo_pelicula
    INNER JOIN esq_peliculas_entrega e ON r.nro_entrega=e.nro_entrega
    WHERE e.fecha_entrega>(CURRENT_DATE - INTERVAL '20 years')
    GROUP BY p.codigo_pelicula, titulo
    ORDER BY cantidad DESC
    LIMIT 20);
    RETURN;
END $$
LANGUAGE 'plpgsql';