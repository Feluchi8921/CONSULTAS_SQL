--1

CREATE ASSERTION ck_medico_sala
CHECK ( NOT EXISTS (
      SELECT 1
      FROM trabaja_en t JOIN investigador i on (t.tipo_proyecto=i.tipo_proyecto
      AND t.cod_proyecto=i.cod_proyecto
      AND i.nro_investigador=t.nro_investigador)
      WHERE SUBSTRING (apellido, 1, 1) BETWEEN 'A' and 'J'
      GROUP BY i.tipo_proyecto, i.cod_proyecto, i.nro_investigador
      HAVING count(*) > 5 ));

--¿Cuáles son las tablas, los eventos y para qué columnas se deben despertar los triggers?
--Tablas: trabaja_en () investigador() tipo_proyecto y cod_proyecto y apellido

    ------------------------------------------------------------
--Ejercicio:2

DROP TABLE IF EXISTS unc_246646_PROYECTO;
DROP TABLE IF EXISTS unc_246646_TRABAJA_EN;
DROP TABLE IF EXISTS unc_246646_AREA_INVESTIGACION;
DROP TABLE IF EXISTS unc_246646_INVESTIGADOR;
    set search_path = unc_246646;

-- Table: AREA_INVESTIGACION
CREATE TABLE unc_246646_AREA_INVESTIGACION (
    cod_area int  NOT NULL,
    descripcion varchar(60)  NOT NULL,
    investigacion_aplicada boolean  NOT NULL,
    CONSTRAINT PK_AREA_INVESTIGACION PRIMARY KEY (cod_area)
);

-- Table: INVESTIGADOR
CREATE TABLE unc_246646_INVESTIGADOR (
    tipo_proyecto char(3)  NOT NULL,
    cod_proyecto int  NOT NULL,
    nro_investigador int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    CONSTRAINT PK_INVESTIGADOR PRIMARY KEY (nro_investigador,tipo_proyecto,cod_proyecto)
);

-- Table: PROYECTO
CREATE TABLE unc_246646_PROYECTO (
    tipo_proyecto char(3)  NOT NULL,
    cod_proyecto int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_PROYECTO PRIMARY KEY (tipo_proyecto,cod_proyecto)
);

-- Table: TRABAJA_EN
CREATE TABLE unc_246646_TRABAJA_EN (
    tipo_proyecto char(3)  NOT NULL,
    cod_proyecto int  NOT NULL,
    nro_investigador int  NOT NULL,
    cod_area int  NOT NULL,
    CONSTRAINT PK_TRABAJA_EN PRIMARY KEY (nro_investigador,tipo_proyecto,cod_proyecto,cod_area)
);

-- Reference: FK_INVESTIGADOR_PROYECTO (table: INVESTIGADOR)
ALTER TABLE unc_246646_INVESTIGADOR ADD CONSTRAINT FK_INVESTIGADOR_PROYECTO
    FOREIGN KEY (tipo_proyecto, cod_proyecto)
    REFERENCES unc_246646_PROYECTO (tipo_proyecto, cod_proyecto);

-- Reference: FK_TRABAJA_EN_AREA_INVESTIGACION (table: TRABAJA_EN)
ALTER TABLE unc_246646_TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_AREA_INVESTIGACION
    FOREIGN KEY (cod_area)
    REFERENCES unc_246646_AREA_INVESTIGACION (cod_area);

-- Reference: FK_TRABAJA_EN_INVESTIGADOR (table: TRABAJA_EN)
ALTER TABLE unc_246646_TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_INVESTIGADOR
    FOREIGN KEY (nro_investigador, tipo_proyecto, cod_proyecto)
    REFERENCES unc_246646_INVESTIGADOR (nro_investigador, tipo_proyecto, cod_proyecto);

-- Datos

INSERT INTO unc_246646_PROYECTO (tipo_proyecto,cod_proyecto,descripcion)
VALUES
  ('K0W',49,'est'),  ('M5G',92,'massa lobortis'),  ('K1J',43,'elementum at,'),  ('K5G',84,'nibh. Aliquam'),  ('B5D',60,'lacinia mattis. Integer'),  ('Y5P',48,'luctus'),
  ('P2U',76,'tellus eu'),  ('Y6X',52,'elit. Curabitur sed'),  ('O4G',11,'imperdiet non,'),  ('V9B',96,'sem semper erat,');

INSERT INTO unc_246646_AREA_INVESTIGACION (cod_area, descripcion, investigacion_aplicada)
VALUES
  (1,'Mira Battle','Yes'),  (2,'Otto Mcclain','No'),  (3,'Ishmael Poole','No'),  (4,'Dale Cochran','Yes'),  (5,'Holly Douglas','Yes'),  (6,'Kylee Horn','No'),
  (7,'Abra Hickman','Yes'),  (8,'Eaton Brady','Yes'),  (9,'Judah Maldonado','Yes'),  (10,'Rebekah Benton','Yes'),  (11,'Armand Vance','Yes'),  (12,'Amaya Jefferson','Yes'),
  (13,'Mohammad Ramsey','Yes'),  (14,'Clarke Ferguson','Yes'),  (15,'Herrod Ortega','No');

INSERT INTO unc_246646_INVESTIGADOR (tipo_proyecto, cod_proyecto, nro_investigador, nombre, apellido)
VALUES
('Y6X', 52, 1, 'Nombre 1', 'Apellido 1'), ('P2U', 76, 2, 'Nombre 2', 'Apellido 2'), ('B5D', 60, 3, 'Nombre 3', 'Apellido 3'), ('K5G', 84, 4, 'Nombre 4', 'Apellido 4'), ('Y6X', 52, 5, 'Nombre 5', 'Apellido 5'),
 ('O4G', 11, 6, 'Nombre 6', 'Apellido 6'), ('V9B', 96, 7, 'Nombre 7', 'Apellido 7'), ('K0W', 49, 8, 'Nombre 8', 'Apellido 8'), ('K5G', 84, 9, 'Nombre 9', 'Apellido 9'), ('Y6X', 52, 10, 'Nombre 10', 'Apellido 10'),
 ('K5G', 84, 11, 'Nombre 11', 'Apellido 11'), ('K0W', 49, 12, 'Nombre 12', 'Apellido 12'), ('V9B', 96, 13, 'Nombre 13', 'Apellido 13'), ('M5G', 92, 14, 'Nombre 14', 'Apellido 14'), ('Y5P', 48, 15, 'Nombre 15', 'Apellido 15'),
 ('K1J', 43, 16, 'Nombre 16', 'Apellido 16'), ('K5G', 84, 17, 'Nombre 17', 'Apellido 17'), ('B5D', 60, 18, 'Nombre 18', 'Apellido 18'), ('K5G', 84, 19, 'Nombre 19', 'Apellido 19'), ('O4G', 11, 20, 'Nombre 20', 'Apellido 20'),
 ('Y5P', 48, 21, 'Nombre 21', 'Apellido 21'), ('B5D', 60, 22, 'Nombre 22', 'Apellido 22'), ('O4G', 11, 23, 'Nombre 23', 'Apellido 23'), ('Y5P', 48, 24, 'Nombre 24', 'Apellido 24'), ('M5G', 92, 25, 'Nombre 25', 'Apellido 25'),
 ('Y5P', 48, 26, 'Nombre 26', 'Apellido 26'), ('Y5P', 48, 27, 'Nombre 27', 'Apellido 27'), ('V9B', 96, 28, 'Nombre 28', 'Apellido 28'), ('V9B', 96, 29, 'Nombre 29', 'Apellido 29'), ('V9B', 96, 30, 'Nombre 30', 'Apellido 30');

INSERT INTO unc_246646_trabaja_en (tipo_proyecto, cod_proyecto, nro_investigador, cod_area)
VALUES
('M5G', 92, 14, 10),('K1J', 43, 16, 4),('Y5P', 48, 15, 1),('B5D', 60, 3, 3),('K5G', 84, 4, 4),('K0W', 49, 12, 6),('V9B', 96, 28, 3),('V9B', 96, 29, 6),('V9B', 96, 7, 10),('Y6X', 52, 10, 5),('O4G', 11, 6, 2),('Y5P', 48, 24, 8),
('O4G', 11, 20, 8),('Y6X', 52, 10, 9),('K5G', 84, 4, 8),('V9B', 96, 29, 1),('M5G', 92, 25, 8),('K0W', 49, 8, 3),('V9B', 96, 29, 9),('B5D', 60, 18, 2),('B5D', 60, 22, 9),('K5G', 84, 19, 10),('Y6X', 52, 1, 2),('O4G', 11, 23, 2),
('B5D', 60, 22, 5),('K5G', 84, 4, 1),('Y5P', 48, 27, 9),('V9B', 96, 13, 1),('B5D', 60, 22, 10),('M5G', 92, 25, 6),('Y5P', 48, 15, 9),('V9B', 96, 29, 4),('K0W', 49, 12, 5),('K1J', 43, 16, 9),('K5G', 84, 19, 7),('Y5P', 48, 26, 8),
('V9B', 96, 7, 4),('Y5P', 48, 27, 7),('K5G', 84, 19, 3),('V9B', 96, 28, 10),('O4G', 11, 23, 7),('O4G', 11, 6, 6),('V9B', 96, 30, 1),('Y5P', 48, 21, 10),('Y5P', 48, 15, 6),('V9B', 96, 7, 2),('O4G', 11, 23, 3),('O4G', 11, 20, 3),
('Y5P', 48, 26, 6),('Y5P', 48, 15, 5),('V9B', 96, 30, 7),('Y5P', 48, 21, 2),('K5G', 84, 4, 2),('K5G', 84, 11, 4),('V9B', 96, 7, 6),('O4G', 11, 23, 4),('Y6X', 52, 10, 7),('V9B', 96, 28, 6),('B5D', 60, 3, 2),('B5D', 60, 18, 1),
('K5G', 84, 9, 8),('Y5P', 48, 26, 1),('O4G', 11, 23, 1),('M5G', 92, 14, 6),('O4G', 11, 6, 1),('Y6X', 52, 5, 7),('V9B', 96, 7, 5),('P2U', 76, 2, 3),('B5D', 60, 3, 4),('B5D', 60, 22, 2),('Y6X', 52, 1, 7),('V9B', 96, 29, 5),
('K0W', 49, 8, 6),('O4G', 11, 20, 2),('K5G', 84, 19, 9),('Y5P', 48, 26, 2),('P2U', 76, 2, 8),('V9B', 96, 30, 2),('K5G', 84, 4, 7),('M5G', 92, 14, 8),('Y5P', 48, 24, 2),('B5D', 60, 3, 9),('V9B', 96, 7, 1),('B5D', 60, 3, 1),
('Y6X', 52, 1, 3),('K5G', 84, 11, 6),('P2U', 76, 2, 9),('Y6X', 52, 10, 10),('B5D', 60, 3, 5),('Y6X', 52, 1, 5),('Y6X', 52, 10, 1),('V9B', 96, 13, 6),('K5G', 84, 9, 4),('V9B', 96, 13, 8),('O4G', 11, 20, 7),('B5D', 60, 18, 5),
('V9B', 96, 30, 3),('Y5P', 48, 15, 4),('B5D', 60, 22, 7),('Y5P', 48, 21, 8),('K5G', 84, 11, 9),('K5G', 84, 9, 2),('P2U', 76, 2, 2),('V9B', 96, 13, 4),('O4G', 11, 6, 5),('K0W', 49, 12, 7),('Y6X', 52, 5, 9),('Y6X', 52, 5, 1),
('M5G', 92, 25, 2),('M5G', 92, 14, 9),('O4G', 11, 6, 4),('V9B', 96, 30, 6),('Y5P', 48, 27, 5),('O4G', 11, 6, 10),('Y6X', 52, 1, 10),('Y5P', 48, 26, 3),('Y6X', 52, 5, 2),('P2U', 76, 2, 10),('Y5P', 48, 15, 10),('K5G', 84, 11, 10),
('Y6X', 52, 5, 6),('Y5P', 48, 24, 6),('P2U', 76, 2, 7),('K5G', 84, 17, 2),('V9B', 96, 13, 7),('Y5P', 48, 26, 9),('Y5P', 48, 15, 8),('K0W', 49, 12, 8),('Y5P', 48, 15, 7),('B5D', 60, 18, 4),('O4G', 11, 20, 4),('K5G', 84, 4, 5),
('O4G', 11, 6, 3),('V9B', 96, 29, 8),('O4G', 11, 6, 7),('Y6X', 52, 1, 8),('K5G', 84, 17, 8),('O4G', 11, 23, 10),('Y6X', 52, 1, 4),('K1J', 43, 16, 8),('V9B', 96, 29, 10),('K1J', 43, 16, 7);

--Se necesita mantener actualizado la cantidad de investigadores por cada proyecto y
-- la cantidad de áreas de investigación por cada proyecto; los nuevos atributos se deben llamar cant_inv, cant_areas.
--Tablas: count(nro_investigador) count(cod_are)
--primero creo una tabla
CREATE TABLE ACTUALIZACION_CANT_INV_Y_AREAS_X_PROY(
    cod_proyecto INT,
    cant_inv INT,
    cant_areas INT
);

--creo la funcion
CREATE OR REPLACE FUNCTION FN_ACTUALIZACION_CANT_INV_Y_AREAS_X_PROY()
RETURNS VOID
AS $$
    BEGIN
    --selecciono la cant_inves y la cant-areas
    INSERT INTO ACTUALIZACION_CANT_INV_Y_AREAS_X_PROY (cod_proyecto, cant_inv, cant_areas)
    (SELECT cod_proyecto, COUNT(*) AS cant_inv, COUNT(DISTINCT cod_area) AS cant_areas
    FROM unc_246646_TRABAJA_EN
    GROUP BY cod_proyecto);
    RETURN;
END
$$
LANGUAGE 'plpgsql';

--Llamar a la funcion
SELECT FN_ACTUALIZACION_CANT_INV_Y_AREAS_X_PROY();

--hago la prueba
SELECT * FROM ACTUALIZACION_CANT_INV_Y_AREAS_X_PROY;

----

create table centro_salud (
    codigo_centro int,
    nombre        VARCHAR(60),
    calle         varchar(60),
    numero        int,
    sala_atencion boolean
);

CREATE OR REPLACE VIEW v_sala_atencion
AS SELECT codigo_centro, nombre, calle, numero,sala_atencion
FROM centro_salud
WHERE sala_atencion = TRUE;

CREATE OR REPLACE VIEW atencion_primaria
AS SELECT * FROM v_sala_atencion
WHERE nombre like '%primaria%'
WITH LOCAL CHECK OPTION;

insert into centro_salud (codigo_centro, nombre, calle, numero, sala_atencion) VALUES (2, 'primaria', 'sara', 2, TRUE);

select * FROM v_sala_atencion;
--se actualiza
select* FROM atencion_primaria;


--se actualizo

INSERT INTO v_sala_atencion (codigo_centro, nombre, calle, numero,sala_atencion)
VALUES (12, 'Atención primaria La Movediza', 'Las Azucenas', 1235, FALSE);
delete from v_sala_atencion;


select * FROM centro_salud; --si
select* from v_sala_atencion; --no
select* from atencion_primaria;

------
--Ejercicio 4

DROP TABLE IF EXISTS e_4_MENSAJE CASCADE;
DROP TABLE IF EXISTS e_4_CONTIENE CASCADE;
DROP TABLE IF EXISTS e_4_ADJUNTO CASCADE;
DROP TABLE IF EXISTS e_4_AUDIO CASCADE;
DROP TABLE IF EXISTS e_4_AUDIO CASCADE;

CREATE TABLE e4_MENSAJE (
    tipo_mensaje int,
    cod_mensaje int,
    texto varchar(50),
    fecha_hora timestamp,
    es_privado boolean,
    CONSTRAINT PK_e4_MENSAJE PRIMARY KEY (tipo_mensaje, cod_mensaje)
);
CREATE TABLE e4_ADJUNTO(
    id_adjunto int,
    tamanio int,
    ubicacion varchar(30),
    fecha_creacion date NULL,
    tipo_a char(1),
    CONSTRAINT PK_e4_ADJUNTO PRIMARY KEY (id_adjunto)
);
CREATE TABLE e4_AUDIO(
    id_adjunto int,
    duracion decimal(10,2),
    CONSTRAINT PK_e4_AUDIO PRIMARY KEY (id_adjunto)
);
ALTER TABLE e4_AUDIO ADD CONSTRAINT FK_e4_CONTIENE_e4_ADJUNTO
    FOREIGN KEY (id_adjunto)
    REFERENCES e4_ADJUNTO (id_adjunto);

CREATE TABLE e4_VIDEO(
    id_adjunto int,
    año int,
    ancho int,
    CONSTRAINT PK_e4_VIDEO PRIMARY KEY (id_adjunto)
);

ALTER TABLE e4_VIDEO ADD CONSTRAINT FK_e4_VIDEO_e4_ADJUNTO
    FOREIGN KEY (id_adjunto)
    REFERENCES e4_ADJUNTO (id_adjunto);

CREATE TABLE e4_CONTIENE(
    id_adjunto int,
    tipo_mensaje int,
    cod_mensaje int,
    descargado char(1) NULL,
    CONSTRAINT PK_e4_CONTIENE PRIMARY KEY (id_adjunto, tipo_mensaje, cod_mensaje)
);
ALTER TABLE e4_CONTIENE ADD CONSTRAINT FK_e4_CONTIENE_e4_ADJUNTO
    FOREIGN KEY (id_adjunto)
    REFERENCES e4_ADJUNTO (id_adjunto);

ALTER TABLE e4_CONTIENE ADD CONSTRAINT FK_e4_CONTIENE_e4_MENSAJE
    FOREIGN KEY (tipo_mensaje, cod_mensaje)
    REFERENCES e4_MENSAJE (tipo_mensaje, cod_mensaje);
---Inserto valores
INSERT INTO e4_MENSAJE (tipo_mensaje, cod_mensaje, texto, fecha_hora, es_privado) VALUES (1, 123, 'texto', '2017-03-31 9:30:20', TRUE);
INSERT INTO e4_MENSAJE (tipo_mensaje, cod_mensaje, texto, fecha_hora, es_privado) VALUES (0, 345, 'Base de Datos', '2020-03-31 9:30:20', TRUE);
INSERT INTO e4_ADJUNTO (id_adjunto, tamanio, ubicacion, fecha_creacion, tipo_a) VALUES (1, 1, 100, '2017-03-31 9:30:20', 'A');
INSERT INTO e4_CONTIENE (id_adjunto, tipo_mensaje, cod_mensaje, descargado) VALUES (1, 1, 123, 'a');

--A
SELECT DISTINCT m.tipo_mensaje, m.cod_mensaje
FROM e4_MENSAJE m JOIN e4_CONTIENE c ON (m.tipo_mensaje = c.tipo_mensaje AND m.cod_mensaje = c.cod_mensaje)
      JOIN e4_ADJUNTO a ON (c.id_adjunto = a.id_adjunto)
      JOIN e4_AUDIO au ON (a.id_adjunto = au.id_adjunto)
WHERE m.texto LIKE 'Base de Datos%'
AND a.tipo_a = 'A'
AND a.tamanio = 100
ORDER BY 1;

--B
SELECT m.tipo_mensaje, m.cod_mensaje
FROM e4_MENSAJE m
WHERE (m.tipo_mensaje, m.cod_mensaje) IN (
                        SELECT c.tipo_mensaje, c.cod_mensaje
                        FROM e4_CONTIENE c
                                JOIN (
                                      SELECT a.id_adjunto
                                              FROM e4_ADJUNTO a
                                              WHERE a.tamanio = 100
                                              AND a.tipo_a = 'A'
                              	) as t
                                ON (c.id_adjunto = t.id_adjunto)
                        )
AND m.texto LIKE 'Base de Datos%'
ORDER BY 1;



