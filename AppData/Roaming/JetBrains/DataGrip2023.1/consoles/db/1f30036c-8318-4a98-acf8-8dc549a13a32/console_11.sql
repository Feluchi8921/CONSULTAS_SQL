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
