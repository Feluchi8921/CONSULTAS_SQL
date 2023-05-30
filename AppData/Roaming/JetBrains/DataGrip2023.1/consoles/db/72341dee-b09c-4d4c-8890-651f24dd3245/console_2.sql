-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-28 00:43:08.428

-- tables
-- Table: ATIENDE
CREATE TABLE ATIENDE (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    cod_centro int  NOT NULL,
    CONSTRAINT PK_ATIENDE PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad,cod_centro)
);

-- Table: CENTRO_SALUD
CREATE TABLE CENTRO_SALUD (
    cod_centro int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sala_atencion boolean  NOT NULL,
    CONSTRAINT PK_CENTRO_SALUD PRIMARY KEY (cod_centro)
);

-- Table: ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: MEDICO
CREATE TABLE MEDICO (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    email varchar(30)  NOT NULL,
    CONSTRAINT PK_MEDICO PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad)
);

-- foreign keys
-- Reference: FK_ATIENDE_CENTRO_SALUD (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_CENTRO_SALUD
    FOREIGN KEY (cod_centro)
    REFERENCES CENTRO_SALUD (cod_centro)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ATIENDE_MEDICO (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_MEDICO
    FOREIGN KEY (nro_matricula, tipo_especialidad, cod_especialidad)
    REFERENCES MEDICO (nro_matricula, tipo_especialidad, cod_especialidad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_MEDICO_ESPECIALIDAD (table: MEDICO)
ALTER TABLE MEDICO ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
    REFERENCES ESPECIALIDAD (tipo_especialidad, cod_especialidad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

CREATE ASSERTION ck_x_atencion_x_especialidad_max_10_medicos(NOT EXISTS(SELECT 1 FROM CENTRO_SALUD cs INNER JOIN ATIENDE a
    ON (cs.cod_centro=a.cod_centro) GROUP BY sala_atencion, tipo_especialidad HAVING COUNT(nro_matricula)>10));

    (SELECT 1 FROM CENTRO_SALUD cs INNER JOIN ATIENDE a
    ON (cs.cod_centro=a.cod_centro) GROUP BY sala_atencion, tipo_especialidad HAVING COUNT(nro_matricula)>10)
