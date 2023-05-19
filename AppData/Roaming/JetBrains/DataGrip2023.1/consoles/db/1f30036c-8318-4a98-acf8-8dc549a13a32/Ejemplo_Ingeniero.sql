-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-05-14 22:48:25.277

-- tables
-- Table: EJ_INGENIERO
CREATE TABLE EJ_INGENIERO (
    id_ingeniero int  NOT NULL,
    nombre varchar  NOT NULL,
    apellido varchar  NOT NULL,
    contacto varchar  NULL,
    especialidad varchar  NOT NULL,
    remuneracion decimal(8,2)  NOT NULL,
    CONSTRAINT PK_INGENIERO PRIMARY KEY (id_ingeniero)
);

-- Table: EJ_PROYECTO
CREATE TABLE EJ_PROYECTO (
    id_sector int  NOT NULL,
    nro_proyecto int  NOT NULL,
    nombre varchar  NOT NULL,
    presupuesto decimal(12,2)  NOT NULL,
    fecha_ini date  NOT NULL,
    fecha_fin date  NULL,
    director int  NOT NULL,
    CONSTRAINT PK_PROYECTO PRIMARY KEY (id_sector,nro_proyecto)
);

-- Table: EJ_SECTOR
CREATE TABLE EJ_SECTOR (
    id_sector int  NOT NULL,
    descripcion varchar  NOT NULL,
    ubicacion varchar  NOT NULL,
    cant_empleados int  NOT NULL,
    CONSTRAINT PK_SECTOR PRIMARY KEY (id_sector)
);

-- Table: EJ_TRABAJA
CREATE TABLE EJ_TRABAJA (
    horas_sem int  NULL,
    id_ingeniero int  NOT NULL,
    id_sector int  NOT NULL,
    nro_proyecto int  NOT NULL,
    CONSTRAINT PK_TRABAJA PRIMARY KEY (id_ingeniero,id_sector,nro_proyecto)
);

-- foreign keys
-- Reference: FK_PROYECTO_INGENIERO (table: EJ_PROYECTO)
ALTER TABLE EJ_PROYECTO ADD CONSTRAINT FK_PROYECTO_INGENIERO
    FOREIGN KEY (director)
    REFERENCES EJ_INGENIERO (id_ingeniero)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PROYECTO_SECTOR (table: EJ_PROYECTO)
ALTER TABLE EJ_PROYECTO ADD CONSTRAINT FK_PROYECTO_SECTOR
    FOREIGN KEY (id_sector)
    REFERENCES EJ_SECTOR (id_sector)
    ON DELETE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_TRABAJA_INGENIERO (table: EJ_TRABAJA)
ALTER TABLE EJ_TRABAJA ADD CONSTRAINT FK_TRABAJA_INGENIERO
    FOREIGN KEY (id_ingeniero)
    REFERENCES EJ_INGENIERO (id_ingeniero)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_TRABAJA_PROYECTO (table: EJ_TRABAJA)
ALTER TABLE EJ_TRABAJA ADD CONSTRAINT FK_TRABAJA_PROYECTO
    FOREIGN KEY (id_sector, nro_proyecto)
    REFERENCES EJ_PROYECTO (id_sector, nro_proyecto)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

insert into ej_ingeniero (id_ingeniero, nombre, apellido, contacto, especialidad, remuneracion)
values (4, 'Sebastian', 'Luguercio', 2494121536, 'DESARROLLO', 900000);
insert into ej_sector (id_sector, descripcion, ubicacion, cant_empleados) values (3,'DESARROLLO', 'Mar del Plata', 500);
insert into ej_proyecto (id_sector, nro_proyecto, nombre, presupuesto, fecha_ini, fecha_fin, director)
VALUES (3,6,'REDESI', 50000, '2022-02-25', NULL, 2);
select * from ej_proyecto;
select * from ej_ingeniero;
select * from ej_trabaja;
select * from ej_sector;
insert into ej_trabaja (horas_sem, id_ingeniero, id_sector, nro_proyecto) VALUES (45,3,1,5);
update ej_ingeniero set especialidad='GESTIÓN IT' where id_ingeniero=3;
update ej_ingeniero set remuneracion=150000 where id_ingeniero=4;
update ej_proyecto set presupuesto=80000 where nro_proyecto=6;

--Las especialidades de los ingenieros pueden ser "INTELIGENCIA EMPRESARIAL" , "TECNOLOGÍAS MOVILES" , "GESTIÓN IT" o "DESARROLLO"
ALTER TABLE ej_ingeniero ADD CONSTRAINT ck_ej_ingeniero_especialidad CHECK (especialidad IN ('INTELIGENCIA EMPRESARIAL', 'TECNOLOGÍAS MOVILES', 'GESTIÓN IT', 'DESARROLLO'));

--La remuneración de un ingeniero debe ser mayor o igual a 25000$ y menor o igual a 250.000$
ALTER TABLE ej_ingeniero ADD CONSTRAINT ck_ej_ingeniero_remuneracion CHECK (remuneracion>=25000 AND remuneracion<=250000);

--Los proyectos sin fecha de finalización asignada no deben superar $100.000 de presupuesto

ALTER TABLE ej_proyecto ADD CONSTRAINT ck_ej_proyecto_fecha_fin_presupuesto CHECK ((fecha_fin IS NULL AND presupuesto<=100000)
    OR (fecha_fin IS NOT NULL));

--Los tipos de especialidad DESARROLLO sólo pueden tener id_ingeniero que van del 1 al 7 para el resto no habría controles.
ALTER TABLE ej_ingeniero ADD CONSTRAINT ck_ej_ingeniero_especialidad_id_ingeniero CHECK (id_ingeniero BETWEEN 1 AND 7);

--En cada proyecto pueden trabajar 10 ingenieros como máximo.
--chequeo que no existan mas de 10 trabajadores. Lo escribo como negacion
ALTER TABLE ej_trabaja ADD CONSTRAINT ck_trabaja_cant_ingenieros CHECK (NOT EXISTS (SELECT id_sector, nro_proyecto FROM ej_trabaja GROUP BY id_sector, nro_proyecto HAVING count(*)>10));
(SELECT id_sector, nro_proyecto FROM ej_trabaja GROUP BY id_sector, nro_proyecto HAVING count(*)>10);

--El director asignado a un proyecto debe haber trabajado al menos en 5 proyectos ya finalizados
CREATE ASSERTION cant_proy_fin NOT EXISTS (SELECT p.director, t.nro_proyecto FROM ej_proyecto p INNER JOIN ej_trabaja t ON (t.id_sector=p.id_sector AND t.nro_proyecto=p.nro_proyecto)
                   WHERE fecha_fin IS NOT NULL  GROUP BY p.director, t.nro_proyecto HAVING count(*)<5);
    (SELECT p.director, t.nro_proyecto FROM ej_proyecto p INNER JOIN ej_trabaja t ON (t.id_sector=p.id_sector AND t.nro_proyecto=p.nro_proyecto)
                   WHERE fecha_fin IS NOT NULL  GROUP BY p.director, t.nro_proyecto HAVING count(*)<5);