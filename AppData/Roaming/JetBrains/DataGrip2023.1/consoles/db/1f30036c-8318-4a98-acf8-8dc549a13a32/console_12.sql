-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 21:22:26.905

-- tables
-- Table: P5P2E4_ALGORITMO
CREATE TABLE P5P2E4_ALGORITMO (
    id_algoritmo int  NOT NULL,
    nombre_metadata varchar(40)  NOT NULL,
    descripcion varchar(256)  NOT NULL,
    costo_computacional varchar(15)  NOT NULL,
    CONSTRAINT PK_P5P2E4_ALGORITMO PRIMARY KEY (id_algoritmo)
);

-- Table: P5P2E4_IMAGEN_MEDICA
CREATE TABLE P5P2E4_IMAGEN_MEDICA (
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    modalidad varchar(80)  NOT NULL,
    descripcion varchar(180)  NOT NULL,
    descripcion_breve varchar(80)  NULL,
    CONSTRAINT PK_P5P2E4_IMAGEN_MEDICA PRIMARY KEY (id_paciente,id_imagen)
);

-- Table: P5P2E4_PACIENTE
CREATE TABLE P5P2E4_PACIENTE (
    id_paciente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    domicilio varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL,
    CONSTRAINT PK_P5P2E4_PACIENTE PRIMARY KEY (id_paciente)
);

-- Table: P5P2E4_PROCESAMIENTO
CREATE TABLE P5P2E4_PROCESAMIENTO (
    id_algoritmo int  NOT NULL,
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    nro_secuencia int  NOT NULL,
    parametro decimal(15,3)  NOT NULL,
    CONSTRAINT PK_P5P2E4_PROCESAMIENTO PRIMARY KEY (id_algoritmo,id_paciente,id_imagen,nro_secuencia)
);

-- foreign keys
-- Reference: FK_P5P2E4_IMAGEN_MEDICA_PACIENTE (table: P5P2E4_IMAGEN_MEDICA)
ALTER TABLE P5P2E4_IMAGEN_MEDICA ADD CONSTRAINT FK_P5P2E4_IMAGEN_MEDICA_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES P5P2E4_PACIENTE (id_paciente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_ALGORITMO (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_ALGORITMO
    FOREIGN KEY (id_algoritmo)
    REFERENCES P5P2E4_ALGORITMO (id_algoritmo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA
    FOREIGN KEY (id_paciente, id_imagen)
    REFERENCES P5P2E4_IMAGEN_MEDICA (id_paciente, id_imagen)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.
--Insertar datos
insert into p5p2e4_paciente (id_paciente, apellido, nombre, domicilio, fecha_nacimiento)
    VALUES (5, 'Aguerralde', 'Alfonso', 'Ayacucho 222', '1993-12-11');
insert into p5p2e4_imagen_medica (id_paciente, id_imagen, modalidad, descripcion, descripcion_breve)
    values (5, 6, 'FLUOROSCOPIA', 'chequeo anual', 'chequeo anual');
select*from p5p2e4_imagen_medica;
insert into p5p2e4_algoritmo (id_algoritmo, nombre_metadata, descripcion, costo_computacional)
    values (4, 'extraccion', 'radiografia medica', 1000);
select*from p5p2e4_algoritmo;
insert into p5p2e4_procesamiento (id_algoritmo, id_paciente, id_imagen, nro_secuencia, parametro)
    values (4, 4, 4 , 345, 14);
select*from p5p2e4_procesamiento;

--Consultas:
--4.a. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA CONVENCIONAL,
-- FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA.
ALTER TABLE p5p2e4_imagen_medica ADD CONSTRAINT ck_imagen_medica_modalidad CHECK
    (modalidad IN('RADIOLOGIA CONVENCIONAL','FLUOROSCOPIA', 'ESTUDIOS RADRIOGRAFICOS CON FLUOROSCOPIA', 'MAMOGRAFIA', 'SONOGRAFIA'));

--4.b. Cada imagen no debe tener más de 5 procesamientos.
ALTER TABLE p5p2e4_procesamiento ADD CONSTRAINT ck_procesamiento_id_imagen CHECK
    (NOT EXISTS (SELECT id_imagen, id_paciente FROM p5p2e4_procesamiento GROUP BY id_imagen, id_paciente HAVING count(*)>5));

--4.c. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento,
-- una indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y
-- controle que la segunda no sea menor que la primera.
--Primero agrego las columnas:
ALTER TABLE p5p2e4_imagen_medica ADD COLUMN fecha_imagen date;
select*from p5p2e4_imagen_medica;
ALTER TABLE p5p2e4_procesamiento ADD COLUMN fecha_procesamiento date;
select*from p5p2e4_procesamiento;
--inserto algunas fechas:
UPDATE p5p2e4_imagen_medica SET fecha_imagen='2022-02-09' WHERE id_paciente=5;
UPDATE p5p2e4_procesamiento SET fecha_procesamiento='2022-03-02' WHERE id_paciente=5;

CREATE ASSERTION ck_imagen_medica_procesamiento_fecha CHECK (NOT EXISTS
    (SELECT * FROM p5p2e4_imagen_medica i INNER JOIN p5p2e4_procesamiento p on (i.id_imagen = p.id_imagen AND i.id_paciente=p.id_paciente)
    WHERE fecha_imagen>fecha_procesamiento));

--creo la subconsulta con lo contrario
SELECT * FROM p5p2e4_imagen_medica i INNER JOIN p5p2e4_procesamiento p on (i.id_imagen = p.id_imagen AND i.id_paciente=p.id_paciente)
    WHERE fecha_imagen>fecha_procesamiento;

--4.d. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
ALTER TABLE p5p2e4_imagen_medica ADD CONSTRAINT ck_imagen_medica_modalidad_fluoroscopia CHECK (NOT EXISTS
    (SELECT id_paciente, modalidad, EXTRACT(YEAR FROM fecha_imagen)  FROM p5p2e4_imagen_medica
        WHERE modalidad='FLUOROSCOPIA' GROUP BY id_paciente,modalidad, EXTRACT(YEAR FROM fecha_imagen) HAVING COUNT(*)>2));

--Realizo una subconsulta con lo contrario:
SELECT id_paciente, modalidad, EXTRACT(YEAR FROM fecha_imagen)  FROM p5p2e4_imagen_medica WHERE modalidad='FLUOROSCOPIA' GROUP BY id_paciente,modalidad, EXTRACT(YEAR FROM fecha_imagen) HAVING COUNT(*)>2;
select*from p5p2e4_imagen_medica WHERE id_paciente=5;

--Antes agrego un paciente que cumpla con menos de dos fluoroscopias anuales para poder chequear la subconsulta:
update p5p2e4_procesamiento SET fecha_procesamiento='2023-05-09' WHERE id_imagen=6;

--4.e. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA
CREATE ASSERTION ck_imagen_medica_procesamiento_algoritmo_costo_fluoroscopia_on CHECK (NOT EXISTS
    (SELECT m.id_imagen FROM p5p2e4_imagen_medica m INNER JOIN p5p2e4_procesamiento p ON (m.id_imagen=p.id_imagen AND m.id_paciente=p.id_paciente)
INNER JOIN p5p2e4_algoritmo a ON (p.id_algoritmo=a.id_algoritmo) WHERE (modalidad='FLUOROSCOPIA' AND costo_computacional='O(n)')));
    --Realizo la subconsulta antes:
SELECT m.id_imagen FROM p5p2e4_imagen_medica m INNER JOIN p5p2e4_procesamiento p ON (m.id_imagen=p.id_imagen AND m.id_paciente=p.id_paciente)
INNER JOIN p5p2e4_algoritmo a ON (p.id_algoritmo=a.id_algoritmo) WHERE (modalidad='FLUOROSCOPIA' AND costo_computacional='O(n)');

