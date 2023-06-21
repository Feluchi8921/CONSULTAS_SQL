-- Los articulos pueden tener como maximo 15 palabras claves
CREATE OR REPLACE FUNCTION FN_MAXIMO_PL_CLAVES() RETURNS Trigger AS $$
    BEGIN
IF((SELECT COUNT(*) FROM CONTIENE WHERE id_articulo = NEW.id_articulo)>14)
    THEN RAISE EXCEPTION 'Supero la cantidad de palabras e el articulo %',
    NEW.id_articulo;
    END IF;
    RETURN NEW;
    END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_MAXIMO_PL_CLAVES
    BEFORE INSERT OR UPDATE OF id_articulo --COLUMNA A LA Q APLICO EL TRIGGER
    ON CONTIENE
    FOR EACH ROW EXECUTE PROCEDURE FN_MAXIMO_PL_CLAVES();

--Cada palabra clave puede aparecer como máximo en 5 artículos.

CREATE OR REPLACE FUNCTION FN_MAX_PL_CLAVES_X_ARTICULO()
RETURNS TRIGGER AS
$$
DECLARE
  cant_pl_claves integer;
BEGIN
  -- Obtener el número de palabras clave en el artículo actual.
  SELECT COUNT(*) INTO cant_pl_claves
  FROM p5p1e1_contiene
  WHERE id_articulo = NEW.id_articulo;
  -- Si el número de palabras clave es superior a 5, genera una excepción.
  IF cant_pl_claves > 4 THEN
    RAISE EXCEPTION '% supero el maximo de 5 articulos por palabra clave';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TR_MAX_PL_CLAVES_X_ARTICULO
BEFORE INSERT OR UPDATE OF idioma, cod_palabra
ON p5p1e1_contiene
FOR EACH ROW
EXECUTE PROCEDURE FN_MAX_PL_CLAVES_X_ARTICULO();

SELECT * FROM p5p1e1_contiene;
SELECT * FROM p5p1e1_articulo;
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor, nacionalidad, fecha_publicacion) VALUES (6, 'Sarasa', 'Desconocido', 'Argentina', '2023-02-06');
UPDATE p5p1e1_contiene SET cod_palabra=123 WHERE id_articulo=2;
--Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras claves,
-- pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar artículos que contengan hasta 10 palabras claves.

create or replace function fn_cantPalabras_contiene()
RETURNS Trigger AS
    $$ declare nac p5p1e1_articulo.NACIONALIDAD%type;
                cant integer;
        begin
               SELECT nacionalidad INTO nac
               FROM p5p1e1_articulo
               WHERE id_articulo=NEW.id_articulo;
               SELECT count(*) into cant
               FROM p5p1e1_contiene
               WHERE id_articulo=NEW.id_articulo;
                IF ((nac='ARG' AND cant>5) OR (nac!='ARG' AND cant>3))
                THEN
                    RAISE EXCEPTION 'ERROR, muchas palabras!';
                END IF;
            RETURN NEW;
        end
    $$
language 'plpgsql';

CREATE TRIGGER tr_pal_cont_art_max
BEFORE INSERT OR UPDATE OF id_articulo ON p5p1e1_contiene
    FOR EACH ROW EXECUTE PROCEDURE fn_cantPalabras_contiene();

create or replace function fn_cantPalabras_articulo()
RETURNS Trigger AS
    $$ declare cant integer;
        begin
               SELECT count(*) into cant
               FROM p5p1e1_contiene
               WHERE id_articulo=NEW.id_articulo;
                IF ((NEW.nacionalidad='ARG' AND cant>5) OR (NEW.nacionalidad!='ARG' AND cant>3))
                -- NEW.nacionalidad refiere a la nacionalidad de la tupla que se esta actualizando
                THEN
                    RAISE EXCEPTION 'ERROR, muchas palabras!';
                END IF;
            RETURN NEW;
        end
    $$
language 'plpgsql';

CREATE TRIGGER tr_max_pal_art
BEFORE UPDATE OF nacionalidad ON p5p1e1_articulo
FOR EACH ROW EXECUTE PROCEDURE fn_cantPalabras_articulo();


--Cada imagen de cada paciente no debe tener más de 5 procesamientos.
CREATE OR REPLACE FUNCTION FN_CANT_PROCESAMIENTOS_X_PACIENTE()
RETURNS Trigger AS $$
    BEGIN
    IF(SELECT count(*) FROM p5p2e4_procesamiento WHERE (id_imagen=NEW.id_imagen AND id_paciente=NEW.id_paciente)>4)
    THEN RAISE EXCEPTION 'Supero la cantidad de % deprocesamientos para el paciente %', NEW.id_imagen, NEW.id_paciente;
    END IF;
    RETURN NEW;
    END $$LANGUAGE 'plpgsql';
CREATE TRIGGER TR_CANT_PROCESAMIENTOS_X_PACIENTE
    BEFORE INSERT OR UPDATE OF id_paciente ON p5p2e4_procesamiento
    FOR EACH ROW EXECUTE PROCEDURE FN_CANT_PROCESAMIENTOS_X_PACIENTE();


--Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento,
--una indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle que la segunda no sea menor que la primera.

CREATE OR REPLACE FUNCTION FN_FECHA_IMAGEN()
RETURNS Trigger AS $$
DECLARE cant Integer;
    BEGIN
    SELECT count(*) INTO cant
    FROM p5p2e4_procesamiento
    WHERE id_paciente=NEW.id_paciente AND id_imagen=NEW.id_imagen AND
    NEW.fecha_imagen>fecha_procesamiento;
    IF (cant>0) THEN
        RAISE EXCEPTION 'La fecha de imagen % no puede ser mayor a la fecha de procesamiento', NEW.fecha_imagen;
END IF;
RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER TR_FECHA_IMAGEN
    BEFORE UPDATE OF id_imagen, id_paciente, fecha_imagen
           ON p5p2e4_imagen_medica
           FOR EACH ROW EXECUTE PROCEDURE FN_FECHA_IMAGEN();

CREATE OR REPLACE FUNCTION FN_FECHA_PROCESAMIENTO()
RETURNS Trigger AS $$
DECLARE cant Integer;
    BEGIN
    SELECT count(*) INTO cant
    FROM p5p2e4_imagen_medica
    WHERE id_paciente=NEW.id_paciente AND id_imagen=NEW.id_imagen AND
    fecha_imagen>NEW.fecha_procesamiento;
    IF (cant>0) THEN
        RAISE EXCEPTION 'La fecha de imagen  no puede ser mayor a la fecha de procesamiento %', NEW.fecha_procesamiento;
END IF;
RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER TR_FECHA_PROCESAMIENTO
    BEFORE UPDATE OF id_imagen, id_paciente, fecha_procesamiento
           ON p5p2e4_procesamiento
           FOR EACH ROW EXECUTE PROCEDURE FN_FECHA_PROCESAMIENTO();
--Sólo se pueden realizar dos FLUOROSCOPIA anuales por paciente
CREATE OR REPLACE FUNCTION FN_MAX_FLUOROSCOPIAS_ANUALES()
RETURNS Trigger AS $$
    DECLARE cant Integer;
    BEGIN
    SELECT COUNT(*) AS cant
    FROM p5p2e4_imagen_medica
    WHERE id_paciente=NEW.id_paciente AND modalidad='FLUROSCOSPIA'
    GROUP BY id_paciente, extract(year from fecha_imagen)=extract(year from NEW.fecha_imagen) ;
    IF (cant>1)
    THEN RAISE EXCEPTION 'Supero la cantidad de Flurosocopias anuales';
    END IF;
RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER TR_TABLA_1_QUE_QUIERO_HACER_INSERT_UPDATE
    BEFORE INSERT OR UPDATE OF id_paciente, modalidad, fecha_imagen
           ON p5p2e4_imagen_medica
           FOR EACH ROW
           WHEN (NEW.modalidad='FLUOROSCOPIA')
           EXECUTE PROCEDURE FN_MAX_FLUOROSCOPIAS_ANUALES();

--C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
--CHECK TUPLA (Tabla: fecha_liq. Atributo: mes_liq, cant_dias)

CREATE OR REPLACE FUNCTION FN_JULIO_DICIEMBRE_DIAS_LIQ_MENOR_IGUAL_5()
RETURNS Trigger AS $$
DECLARE cant Integer;
    BEGIN
    SELECT COUNT(*) AS cant
    FROM p5p2e5_fecha_liq
    WHERE mes_liq=NEW.mes_liq AND (NEW.mes_liq=7 OR NEW.mes_liq=12) AND cant_dias>5;
    IF(cant>0)
    THEN RAISE EXCEPTION 'El mes % no puede superar los 5 días de promo', NEW.mes_liq;
    END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_FN_JULIO_DICIEMBRE_DIAS_LIQ_MENOR_IGUAL_5
    BEFORE INSERT OR UPDATE OF mes_liq, cant_dias
           ON p5p2e5_fecha_liq
           FOR EACH ROW EXECUTE PROCEDURE FN_JULIO_DICIEMBRE_DIAS_LIQ_MENOR_IGUAL_5();
--Hago la prueba para que se despierte el trigger:
INSERT INTO p5p2e5_fecha_liq (dia_liq, mes_liq, cant_dias) VALUES (12, 7, 6);
UPDATE p5p2e5_fecha_liq SET cant_dias=7 WHERE mes_liq=7;

--D. Las prendas de categoría ‘oferta’ no tienen descuentos.
--CHECK GENERAL (Tablas: prenda, venta. Atributos: id_prenda, categoria, descuento)

CREATE OR REPLACE FUNCTION FN_OFERTAS_SIN_DESCUENTO()
RETURNS Trigger AS $$
DECLARE cant Integer;
    BEGIN
    SELECT COUNT(*) AS cant
    FROM p5p2e5_venta
    WHERE id_prenda=NEW.id_prenda AND categoria='oferta' AND descuento!=0;
    IF(cant>0)
    THEN RAISE EXCEPTION 'La categoria oferta no tiene descuentos';
    END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_OFERTAS_SIN_DESCUENTO
    BEFORE INSERT OR UPDATE OF categoria
           ON p5p2e5_prenda
           FOR EACH ROW
           WHEN (NEW.categoria='oferta')
           EXECUTE PROCEDURE FN_OFERTAS_SIN_DESCUENTO();

DROP TRIGGER IF EXISTS TR_OFERTAS_SIN_DESCUENTO ON unc_246646.p5p2e5_prenda;
INSERT INTO p5p2e5_prenda (id_prenda, precio, descripcion, tipo, categoria) VALUES (5,20000, 'sarasa', 'hombre', 'oferta');
UPDATE p5p2e5_prenda SET categoria='oferta' WHERE id_prenda=4;

--Ejercicio 4
CREATE TABLE Pelicula AS
SELECT * FROM unc_esq_peliculas.pelicula;

CREATE TABLE estadistica AS
SELECT genero, COUNT(*) total_peliculas, count (distinct idioma) cantidad_idiomas FROM Pelicula  GROUP BY genero;

SELECT * FROM Pelicula;
SELECT* FROM estadistica;

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_TABLA()
RETURNS Trigger AS $$
DECLARE gen VARCHAR(30);
DECLARE idiom VARCHAR(20);
DECLARE total_peliculas INTEGER;
DECLARE cantidad_idiomas INTEGER;
    BEGIN
    SELECT genero AS gen, idioma AS idiom, COUNT(*) AS cantidad_peliculas, count (distinct idioma) AS cantidad_idiomas
    FROM Pelicula
    group by genero, idioma;
    IF(cant>0)
    THEN RAISE EXCEPTION 'error';
    END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_ACTUALIZAR_TABLA
    BEFORE INSERT OR UPDATE OF genero, idioma
           ON Pelicula
           FOR EACH ROW EXECUTE PROCEDURE FN_ACTUALIZAR_TABLA();

---Para el esquema unc_voluntarios considere que se quiere mantener un registro de quién y cuándo realizó actualizaciones sobre la tabla TAREA en la tabla HIS_TAREA. Dicha tabla tiene la siguiente estructura:
--HIS_TAREA(nro_registro, fecha, operación, usuario)
CREATE TABLE his_tarea(
    nro_registro int,
    fecha date,
    operacion int,
    usuario varchar(20),
    id_tarea varchar(10) NOT NULL
);
ALTER TABLE his_tarea ADD CONSTRAINT FK_HIS_TAREA_TAREA
    FOREIGN KEY (id_tarea)
    REFERENCES unc_esq_voluntario.tarea(id_tarea);

DROP TABLE his_tarea;

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_TABLA_HIS_TAREA()
RETURNS Trigger AS $$
    BEGIN
    IF TG_OP='INSERT' THEN
        INSERT INTO his_tarea (nro_registro, fecha, operacion, usuario, id_tarea) VALUES (nro_registro=NEW.nro_registro, fecha=NEW.fecha, operacion=NEW.operacion, usuario=NEW.usuario, id_tarea=NEW.id_tarea);
    RETURN NEW;
    END IF;
    IF TG_OP='UPDATE' THEN
        UPDATE his_tarea SET nro_registro=NEW.nro_registro, fecha=NEW.fecha, operacion=NEW.operacion, usuario=NEW.usuario WHERE id_tarea=NEW.id_tarea;
    RETURN NEW;
    END IF;
    IF TG_OP='DELETE' THEN
        DELETE FROM his_tarea
    end if;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_ACTUALIZAR_TABLA_HIS_TAREA
    AFTER INSERT OR UPDATE OF nro_registro, fecha, operacion, usuario, id_tarea OR DELETE
           ON his_tarea
           FOR EACH ROW
           EXECUTE PROCEDURE FN_ACTUALIZAR_TABLA_HIS_TAREA();