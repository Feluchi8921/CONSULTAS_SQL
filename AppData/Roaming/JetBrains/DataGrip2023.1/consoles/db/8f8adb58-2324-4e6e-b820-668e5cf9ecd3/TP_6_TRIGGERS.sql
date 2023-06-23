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
    IF(cantidad_idiomas>0)
    THEN RAISE EXCEPTION 'error';
    END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_ACTUALIZAR_TABLA
    BEFORE INSERT OR UPDATE OF genero, idioma
           ON Pelicula
           FOR EACH ROW EXECUTE PROCEDURE FN_ACTUALIZAR_TABLA();
-----------------------------------------TRABAJO PRACTICO N6 TRIGGER PARTE 2-------------------

--EJERCICIO 1

---Para el esquema unc_voluntarios considere que se quiere mantener un registro de quién y cuándo
-- realizó actualizaciones sobre la tabla TAREA en la tabla HIS_TAREA. Dicha tabla tiene la siguiente estructura:
--HIS_TAREA(nro_registro, fecha, operación, usuario)
DROP TABLE IF EXISTS his_tarea;
CREATE TABLE his_tarea(
    nro_registro SERIAL,
    fecha DATE,
    operacion VARCHAR(20),
    usuario VARCHAR(20),
    PRIMARY KEY(nro_registro)
);
SELECT * FROM unc_esq_peliculas.tarea;
--1. Funcion
CREATE OR REPLACE FUNCTION ACTUALIZAR_TABLA_HIS_TAREA()
    RETURNS TRIGGER AS $$
    BEGIN
        --Actualizacion por insert:
        IF TG_OP='INSERT' THEN             --si inserto en tarea, inserto un registro en his_tarea con la operacion insert
            INSERT INTO his_tarea (fecha, operacion, usuario) VALUES (CURRENT_DATE, TG_OP, CURRENT_USER);
        RETURN NEW;
        END IF;
        --Actualizacion por update:
        IF TG_OP='UPDATE' THEN          --si modifico la tabla tarea, inserto un registro en his_tarea con la operacion update
            INSERT INTO his_tarea (fecha, operacion, usuario) VALUES (CURRENT_DATE, TG_OP, CURRENT_USER);       --inserto el nuevo valor
        RETURN NEW;
        END IF;
        --Actualizacion por delete:
        IF TG_OP='DELETE' THEN          --si elimino un resgitro de tarea, inserto un registro en his_tarea con la operacion delete
            INSERT INTO his_tarea (fecha, operacion, usuario) VALUES (CURRENT_DATE, TG_OP, CURRENT_USER);       --inserto el nuevo valor
        RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

--2. Trigger

CREATE TRIGGER TR_ACTUALIZAR_TABLA_HIS_TAREA
AFTER INSERT OR UPDATE OF id_tarea, nombre_tarea, sueldo_maximo, sueldo_minimo OR DELETE
ON esq_peliculas_tarea
FOR EACH STATEMENT
EXECUTE PROCEDURE ACTUALIZAR_TABLA_HIS_TAREA();

DROP TRIGGER IF EXISTS TR_ACTUALIZAR_TABLA_HIS_TAREA ON esq_peliculas_tarea;

--3. Pruebas
INSERT INTO esq_peliculas_tarea (id_tarea, nombre_tarea, sueldo_maximo, sueldo_minimo) VALUES (20000, 'Tarea 18000', 15000, 12000);
UPDATE esq_peliculas_tarea SET sueldo_minimo=16000 WHERE id_tarea='20000';
INSERT INTO esq_peliculas_tarea (id_tarea, nombre_tarea, sueldo_maximo, sueldo_minimo) VALUES (20001, 'Tarea 2001', 18000, 13000);
DELETE FROM esq_peliculas_tarea WHERE id_tarea='20001';


--Muestre los resultados de las tablas si se ejecuta la operación:
--DELETE FROM TAREA
--WHERE id_tarea like ‘AD%’;
--Según el o los triggers definidos sean FOR EACH ROW o FOR EACH STATEMENT. Evalúe la diferencia entre ambos tipos de granularidad.

DELETE FROM esq_peliculas_tarea
WHERE id_tarea like 'AD%';

DROP TRIGGER IF EXISTS TR_ACTUALIZAR_TABLA_HIS_TAREA ON esq_peliculas_tarea;

CREATE TRIGGER TR_ACTUALIZAR_TABLA_HIS_TAREA
AFTER INSERT OR UPDATE OR DELETE ON esq_peliculas_tarea
FOR EACH ROW
EXECUTE PROCEDURE ACTUALIZAR_TABLA_HIS_TAREA();

--Ejercicio 2

--Completar una tabla denominada MAS_ENTREGADAS con los datos de las 20 películas más entregadas
-- en los últimos seis meses desde la ejecución del procedimiento. Esta tabla por lo menos
-- debe tener las columnas código_pelicula, nombre,  cantidad_de_entregas
-- (en caso de coincidir en cantidad de entrega ordenar por código de película).
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

--DROP FUNCTION fn_actualizar_tabla_mas_entregadas() CASCADE;
SELECT FN_ACTUALIZAR_TABLA_MAS_ENTREGADAS()  --ejecuto la funcion

--Generar los datos para una tabla denominada SUELDOS,
-- con los datos de los empleados cuyas comisiones superen a la media del departamento en el que trabajan.
-- Esta tabla debe tener las columnas id_empleado, apellido, nombre, sueldo, porc_comision.
DROP TABLE IF EXISTS sueldos;

CREATE TABLE sueldos(
    id_empleado NUMERIC(6) NOT NULL,
    apellido VARCHAR(30),
    nombre VARCHAR(30),
    sueldo NUMERIC(8,2),
    porc_coimision NUMERIC(6,2)
);

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_TABLA_SUELDOS()
    RETURNS VOID
AS $$
    BEGIN
    DELETE FROM sueldos;
    INSERT INTO sueldos (id_empleado, apellido, nombre, sueldo, porc_coimision)
    (SELECT e.id_empleado, e.apellido, e.nombre, e.sueldo, e.porc_comision
FROM esq_peliculas_empleado e
    INNER JOIN esq_peliculas_departamento d ON e.id_distribuidor = d.id_distribuidor AND e.id_departamento = d.id_departamento
WHERE e.porc_comision > (SELECT AVG(porc_comision) FROM esq_peliculas_empleado em
                                                   WHERE d.id_departamento=em.id_departamento AND d.id_distribuidor=em.id_distribuidor));
RETURN;
END $$
LANGUAGE 'plpgsql';

SELECT FN_ACTUALIZAR_TABLA_SUELDOS();

SELECT * FROM sueldos;

SELECT e.id_empleado, e.apellido, e.nombre, e.sueldo, e.porc_comision
FROM esq_peliculas_empleado e
    INNER JOIN esq_peliculas_departamento d ON e.id_distribuidor = d.id_distribuidor AND e.id_departamento = d.id_departamento
WHERE e.porc_comision > (SELECT AVG(porc_comision) FROM esq_peliculas_empleado em WHERE d.id_departamento=em.id_departamento AND d.id_distribuidor=em.id_distribuidor);

--Cambiar el distribuidor de las entregas sucedidas a partir de una fecha dada,
-- siendo que el par de valores de distribuidor viejo y distribuidor nuevo es variable.

--Crear Funcion
CREATE OR REPLACE FUNCTION FN_CAMBIAR_DISTRIBUIDOR(distribuidor_id INT)
RETURNS void AS $$
    BEGIN
    --Selecciono todos los distribuidores con entregas despues del 2005
    UPDATE esq_peliculas_entrega
    SET id_distribuidor = distribuidor_id
    WHERE fecha_entrega > '2006-12-03';
RETURN;
END $$
LANGUAGE 'plpgsql';
--Llamar a la funcion
SELECT FN_CAMBIAR_DISTRIBUIDOR(5000);

--Dejo el borrado por si lo necesito
DROP FUNCTION FN_CAMBIAR_DISTRIBUIDOR();
--Inserto un distribuidor nuevo para identificarlo mas rapido
INSERT INTO esq_peliculas_distribuidor (id_distribuidor, nombre, direccion, telefono, tipo)
    VALUES (5000,'Felicitas', 'Mistral xxx', 24940000, 'I');

--Hago las pruebas
SELECT*FROM esq_peliculas_entrega WHERE id_distribuidor=5000;
SELECT * FROM esq_peliculas_distribuidor WHERE id_distribuidor=5000;

INSERT INTO esq_peliculas_distribuidor (id_distribuidor, nombre, direccion, telefono, tipo)
    VALUES (5000,'Felicitas', 'Mistral xxx', 24940000, 'I');

--Ejercicio 3
--Para el esquema unc_voluntarios se desea conocer la cantidad de voluntarios que hay en cada tarea
-- al inicio de cada mes y guardarla a lo largo de los meses. Para esto es necesario hacer un procedimiento
-- que calcule la cantidad y la almacene en una tabla denominada CANT_VOLUNTARIOSXTAREA con la siguiente estructura:
--CANT_VOLUNTARIOSXTAREA (anio, mes, id_tarea, nombre_tarea, cant_voluntarios)

--Tabla unc_voluntarios (count(nro_voluntario), group by tarea)

CREATE TABLE cant_voluntariosxtarea(
    anio INTEGER,
    mes INTEGER,
    id_tarea VARCHAR(10),
    nombre_tarea VARCHAR(40),
    cant_voluntarios INTEGER
);
DROP TABLE IF EXISTS cant_voluntariosxtarea;

CREATE PROCEDURE PR_ACTUALIZACION_MENSUAL_CANT_VOLUNTARIOS()
AS $$
    DECLARE cant_vol INT;
    DECLARE tarea INT;
    DECLARE nombre VARCHAR(40);
    BEGIN

    SELECT CURRENT_DATE;

    --Necisito seleccionar la cantidad de voluntarios por tarea, id y nombre
    SELECT DISTINCT t.id_tarea, t.nombre_tarea, COUNT(*) FROM unc_esq_voluntario.voluntario v
    INNER JOIN unc_esq_voluntario.tarea t on t.id_tarea = v.id_tarea
    WHERE (EXTRACT(DAY FROM (SELECT CURRENT_DATE)))=1 GROUP BY t.id_tarea, t.nombre_tarea;
    --aca iria un where inicio mes= mes_current_date
    --Inserto la cantidad y los otros datos en la nueva tabla
    INSERT INTO cant_voluntariosxtarea (anio, mes, id_tarea, nombre_tarea, cant_voluntarios) VALUES
    (EXTRACT(YEARS FROM current_date), EXTRACT(MONTHS FROM current_date), tarea, nombre, cant_vol);
END $$
LANGUAGE 'plpgsql';

--Llamo al procedimiento
SELECT PR_ACTUALIZACION_MENSUAL_CANT_VOLUNTARIOS();

--Pruebo el select
SELECT DISTINCT id_tarea, COUNT(*) FROM unc_esq_voluntario.voluntario GROUP BY id_tarea;


