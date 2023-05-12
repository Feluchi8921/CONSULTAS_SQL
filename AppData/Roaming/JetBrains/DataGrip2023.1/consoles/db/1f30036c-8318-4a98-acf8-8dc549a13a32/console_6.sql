-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-12 13:48:27.09

-- tables
-- Table: continente
CREATE TABLE continente (
    id_continente int  NOT NULL,
    nombre_continente varchar(30)  NULL,
    CONSTRAINT continente_pk PRIMARY KEY (id_continente)
);

-- Table: direccion
CREATE TABLE direccion (
    id_direccion int  NOT NULL,
    calle varchar(40)  NULL,
    codigo_postal varchar(12)  NULL,
    provincia varchar(25)  NULL,
    ciudad varchar(30)  NOT NULL,
    id_pais int  NOT NULL,
    CONSTRAINT FK_DIRECCION UNIQUE (id_pais) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT direccion_pk PRIMARY KEY (id_direccion)
);

-- Table: historico
CREATE TABLE historico (
    nro_voluntario int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NOT NULL,
    id_tarea char(10)  NOT NULL,
    id_institucion int  NULL,
    CONSTRAINT FK_HISTORICO UNIQUE (nro_voluntario, id_tarea, id_institucion) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT historico_pk PRIMARY KEY (fecha_inicio,nro_voluntario)
);

-- Table: institucion
CREATE TABLE institucion (
    id_institucion int  NOT NULL,
    nombre_institucion varchar(60)  NOT NULL,
    id_director int  NULL,
    id_direccion int  NULL,
    CONSTRAINT FK_INSTITUCION UNIQUE (id_direccion, id_director) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT institucion_pk PRIMARY KEY (id_institucion)
);

-- Table: pais
CREATE TABLE pais (
    id_pais int  NOT NULL,
    nombre_pais varchar(20)  NULL,
    id_continente int  NOT NULL,
    CONSTRAINT FK_PAIS UNIQUE (id_continente) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT pais_pk PRIMARY KEY (id_pais)
);

-- Table: tarea
CREATE TABLE tarea (
    id_tarea char(10)  NOT NULL,
    nombre_tarea varchar(40)  NOT NULL,
    min_horas int  NULL,
    max_horas int  NULL,
    CONSTRAINT tarea_pk PRIMARY KEY (id_tarea)
);

-- Table: voluntario
CREATE TABLE voluntario (
    nro_voluntario int  NOT NULL,
    nombre varchar(20)  NULL,
    apellido varchar(25)  NOT NULL,
    e_mail varchar(25)  NOT NULL,
    telefono varchar(20)  NULL,
    fecha_nacimiento date  NOT NULL,
    horas_aportadas decimal(8,2)  NULL,
    porcentaje decimal(2,2)  NULL,
    id_tarea char(10)  NOT NULL,
    id_institucion int  NULL,
    id_coordinador int  NULL,
    CONSTRAINT FK_VOLUNTARIO UNIQUE (id_tarea, id_institucion) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT voluntario_pk PRIMARY KEY (nro_voluntario)
);

-- foreign keys
-- Reference: direccion_pais (table: direccion)
ALTER TABLE direccion ADD CONSTRAINT direccion_pais
    FOREIGN KEY (id_pais)
    REFERENCES pais (id_pais)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: historico_institucion (table: historico)
ALTER TABLE historico ADD CONSTRAINT historico_institucion
    FOREIGN KEY (id_institucion)
    REFERENCES institucion (id_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: historico_tarea (table: historico)
ALTER TABLE historico ADD CONSTRAINT historico_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES tarea (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: historico_voluntario (table: historico)
ALTER TABLE historico ADD CONSTRAINT historico_voluntario
    FOREIGN KEY (nro_voluntario)
    REFERENCES voluntario (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: institucion_direccion (table: institucion)
ALTER TABLE institucion ADD CONSTRAINT institucion_direccion
    FOREIGN KEY (id_direccion)
    REFERENCES direccion (id_direccion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: institucion_voluntario (table: institucion)
ALTER TABLE institucion ADD CONSTRAINT institucion_voluntario
    FOREIGN KEY (id_director)
    REFERENCES voluntario (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: pais_continente (table: pais)
ALTER TABLE pais ADD CONSTRAINT pais_continente
    FOREIGN KEY (id_continente)
    REFERENCES continente (id_continente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: voluntario_institucion (table: voluntario)
ALTER TABLE voluntario ADD CONSTRAINT voluntario_institucion
    FOREIGN KEY (id_institucion)
    REFERENCES institucion (id_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: voluntario_tarea (table: voluntario)
ALTER TABLE voluntario ADD CONSTRAINT voluntario_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES tarea (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: voluntario_voluntario (table: voluntario)
ALTER TABLE voluntario ADD CONSTRAINT voluntario_voluntario
    FOREIGN KEY (id_coordinador)
    REFERENCES voluntario (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

