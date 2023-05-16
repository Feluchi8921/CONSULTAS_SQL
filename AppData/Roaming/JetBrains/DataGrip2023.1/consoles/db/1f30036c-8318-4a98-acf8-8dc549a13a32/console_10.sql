-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

-- tables
-- Table: P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(120)  NOT NULL,
    autor varchar(30)  NOT NULL,
    CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Table: P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo int  NOT NULL,
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    descripcion varchar(25)  NOT NULL,
    CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P1E1_CONTIENE_ARTICULO (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.
----------------------------------------------------------------------------------------------------------------
-----Consultas:
SELECT * FROM p5p1e1_articulo;
UPDATE  p5p1e1_articulo SET titulo='Inteligencia emocional', autor='Daniel Goleman', nacionalidad='Inglés' where id_articulo=3;

--3.a. Controlar que las nacionalidades sean 'Argentina' 'Español' 'Inglés' 'Alemán' o 'Chilena'.
--Agrego la columna porque no existe
ALTER TABLE p5p1e1_articulo ADD column nacionalidad varchar (100);
--Agrego la restriccion ADD CONSTRAINT ck_nombreTabla_atributo
ALTER TABLE p5p1e1_articulo ADD CONSTRAINT ck_articulo_nacionalidad
    CHECK (nacionalidad IN( 'Argentina', 'Español', 'Inglés', 'Alemán', 'Chilena'));

--3.b Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales al 2010.
--Agrego la columna fecha_publicacion
ALTER TABLE p5p1e1_articulo ADD column fecha_publicacion date;
UPDATE p5p1e1_articulo SET fecha_publicacion='2012-11-05' where id_articulo=4;
SELECT * FROM p5p1e1_articulo;
ALTER TABLE p5p1e1_articulo ADD CONSTRAINT ck_articulo_fecha_publicacion CHECK (EXTRACT(YEAR FROM fecha_publicacion)>=2010);

--3.c Cada palabra clave puede aparecer como máximo en 5 artículos.
--(necesito solo la tabla contiene)
--Dame las palabras que tienen mas de 5 articulos
--no se puede utilizar un subquery en un check (utilizar manera procedural)
--De manera declarativa:
ALTER TABLE p5p1e1_contiene ADD CONSTRAINT ck_contiene_cod_palabra CHECK
   (NOT EXISTS (SELECT cod_palabra, idioma FROM p5p1e1_contiene GROUP BY cod_palabra, idioma HAVING COUNT(*)>5));

--D. Sólo los autores argentinos pueden publicar artículos que contengan más de
-- 10 palabras claves, pero con un tope de 15 palabras, el resto de los autores
-- sólo pueden publicar artículos que contengan hasta 10 palabras claves.

CREATE ASSERTION CK_CANTIDAD_PALABRAS CHECK (NOT EXISTS(SELECT 1 FROM p5p2e3_articulo WHERE (nacionalidad LIKE 'Argentina' AND
    id_articulo IN (SELECT id_articulo FROM p5p2e3_contiene GROUP BY id_articulo HAVING COUNT(*)>15)) OR
    (nacionalidad NOT LIKE 'Argentina' AND id_articulo IN (SELECT id_articulo FROM p5p2e3_contiene GROUP BY id_articulo
    HAVING COUNT(*)>10) )));