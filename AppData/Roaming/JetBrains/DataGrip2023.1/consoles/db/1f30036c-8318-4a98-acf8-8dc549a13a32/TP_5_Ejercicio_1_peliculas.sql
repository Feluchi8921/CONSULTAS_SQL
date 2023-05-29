--1. Para cada tarea el sueldo máximo debe ser mayor que el sueldo mínimo.
ALTER TABLE esq_peliculas_tarea ADD CONSTRAINT ck_sueldo_tarea_mayor_sueldo_minimo CHECK
    (NOT EXISTS(SELECT id_tarea FROM esq_peliculas_tarea GROUP BY id_tarea HAVING sueldo_maximo>sueldo_minimo));
--2. No puede haber más de 70 empleados en cada departamento.
CREATE ASSERTION ck_cant_empleados_menor_70 CHECK (NOT EXISTS
(SELECT d.nombre, COUNT(id_empleado) AS CANT_EMPLEADOS FROM esq_peliculas_empleado e INNER JOIN esq_peliculas_departamento
    d ON (e.id_departamento=d.id_departamento
AND e.id_distribuidor=d.id_distribuidor) GROUP BY  d.nombre HAVING COUNT(*) >70));

--3. Los empleados deben tener jefes que pertenezcan al mismo departamento.
ALTER TABLE esq_peliculas_departamento ADD CONSTRAINT ck_empleados_jefes_mismo_departamento CHECK
    (NOT EXISTS (SELECT 1 FROM esq_peliculas_empleado e INNER JOIN esq_peliculas_empleado j ON e.id_jefe = j.id_empleado
WHERE e.id_departamento != j.id_departamento AND e.id_distribuidor != j.id_distribuidor));

--4. Todas las entregas, tienen que ser de películas de un mismo idioma.
CREATE ASSERTION ck_entregas_mismo_idioma (NOT EXISTS
    (SELECT 1 FROM esq_peliculas_renglon_entrega e INNER JOIN esq_peliculas_pelicula p ON
    e.codigo_pelicula=p.codigo_pelicula GROUP BY idioma HAVING COUNT (*)!=1));

--5. No pueden haber más de 10 empresas productoras por ciudad.
CREATE ASSERTION ck_hasta_10_empresas_productoras_x_ciudad (NOT EXISTS
    (SELECT 1 FROM esq_peliculas_pelicula p INNER JOIN esq_peliculas_empresa_productora ep ON
    (ep.codigo_productora=p.codigo_productora) INNER JOIN esq_peliculas_ciudad c on c.id_ciudad = ep.id_ciudad
GROUP BY c.id_ciudad, ep.codigo_productora HAVING COUNT(*)<10));

SELECT ep.codigo_productora, c.nombre_ciudad, COUNT(*) AS NUM_PROD FROM esq_peliculas_pelicula p INNER JOIN esq_peliculas_empresa_productora ep ON
    (ep.codigo_productora=p.codigo_productora) INNER JOIN esq_peliculas_ciudad c on c.id_ciudad = ep.id_ciudad
GROUP BY c.id_ciudad, ep.codigo_productora HAVING COUNT(*)<10;

--6.Para cada película, si el formato es 8mm, el idioma tiene que ser francés.

ALTER TABLE unc_esq_peliculas.pelicula
ADD CONSTRAINT ck_idioma_formato
CHECK (NOT EXISTS (
SELECT 1 FROM unc_esq_peliculas.pelicula WHERE formato = 'Formato 8' AND idioma !='Frances'));

--Alternativa:

ALTER TABLE unc_esq_peliculas.pelicula ADD CONSTRAINT ck_formato_idioma
CHECK((formato = '8mm' AND idioma = 'Frances') OR formato != '8mm');

--7. El teléfono de los distribuidores Nacionales debe tener la misma característica que la de su distribuidor mayorista.

SELECT substring(telefono, 0, 2) caracteristica FROM esq_peliculas_nacional n INNER JOIN esq_peliculas_distribuidor d
ON d.id_distribuidor=n.id_distribuidor ;

CREATE ASSERTION ck_telef_distrib CHECK(NOT EXISTS(
SELECT 1 FROM distribuidor d JOIN nacional n ON d.id_distribuidor = n.id_distribuidor JOIN distribuidor di
    ON n.id_distrib_mayorista = di.id_distribuidor
WHERE d.LEFT(telefono, 3) != di.LEFT(telefono, 3)));

--8.  Liste los 3 países donde residan las productoras con mayor cantidad de películas producidas.
SELECT ep.codigo_productora, c.id_pais, COUNT(codigo_pelicula) FROM unc_esq_peliculas.pelicula p INNER JOIN unc_esq_peliculas.empresa_productora ep
ON p.codigo_productora=ep.codigo_productora INNER JOIN unc_esq_peliculas.ciudad c ON ep.id_ciudad = c.id_ciudad
GROUP BY ep.codigo_productora, c.id_pais ORDER BY COUNT(codigo_pelicula) DESC LIMIT 3;

SELECT c.id_pais
FROM unc_esq_peliculas.ciudad c JOIN unc_esq_peliculas.empresa_productora e ON c.id_ciudad = e.id_ciudad JOIN unc_esq_peliculas.pelicula p ON p.codigo_productora = e.codigo_productora
GROUP BY e.codigo_productora, c.id_pais
ORDER BY count(codigo_pelicula) desc
LIMIT 3;

