-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-12 14:07:13.907

-- tables
-- Table: voluntarios_continente
CREATE TABLE voluntarios_continente (
    id_continente int  NOT NULL,
    nombre_continente varchar(30)  NULL,
    CONSTRAINT voluntarios_continente_pk PRIMARY KEY (id_continente)
);

-- Table: voluntarios_direccion
CREATE TABLE voluntarios_direccion (
    id_direccion int  NOT NULL,
    calle varchar(40)  NULL,
    codigo_postal varchar(12)  NULL,
    provincia varchar(25)  NULL,
    ciudad varchar(30)  NOT NULL,
    id_pais int  NOT NULL,
    CONSTRAINT FK_DIRECCION UNIQUE (id_pais) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT voluntarios_direccion_pk PRIMARY KEY (id_direccion)
);

-- Table: voluntarios_historico
CREATE TABLE voluntarios_historico (
    nro_voluntario int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NOT NULL,
    id_tarea char(10)  NOT NULL,
    id_institucion int  NULL,
    CONSTRAINT FK_HISTORICO UNIQUE (nro_voluntario, id_tarea, id_institucion) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT voluntarios_historico_pk PRIMARY KEY (fecha_inicio,nro_voluntario)
);

-- Table: voluntarios_institucion
CREATE TABLE voluntarios_institucion (
    id_institucion int  NOT NULL,
    nombre_institucion varchar(60)  NOT NULL,
    id_director int  NULL,
    id_direccion int  NULL,
    CONSTRAINT FK_INSTITUCION UNIQUE (id_direccion, id_director) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT voluntarios_institucion_pk PRIMARY KEY (id_institucion)
);

-- Table: voluntarios_pais
CREATE TABLE voluntarios_pais (
    id_pais int  NOT NULL,
    nombre_pais varchar(20)  NULL,
    id_continente int  NOT NULL,
    CONSTRAINT FK_PAIS UNIQUE (id_continente) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT voluntarios_pais_pk PRIMARY KEY (id_pais)
);

-- Table: voluntarios_tarea
CREATE TABLE voluntarios_tarea (
    id_tarea char(10)  NOT NULL,
    nombre_tarea varchar(40)  NOT NULL,
    min_horas int  NULL,
    max_horas int  NULL,
    CONSTRAINT voluntarios_tarea_pk PRIMARY KEY (id_tarea)
);

-- Table: voluntarios_voluntario
CREATE TABLE voluntarios_voluntario (
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
    CONSTRAINT voluntarios_voluntario_pk PRIMARY KEY (nro_voluntario)
);

-- foreign keys
-- Reference: direccion_pais (table: voluntarios_direccion)
ALTER TABLE voluntarios_direccion ADD CONSTRAINT direccion_pais
    FOREIGN KEY (id_pais)
    REFERENCES voluntarios_pais (id_pais)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: historico_institucion (table: voluntarios_historico)
ALTER TABLE voluntarios_historico ADD CONSTRAINT historico_institucion
    FOREIGN KEY (id_institucion)
    REFERENCES voluntarios_institucion (id_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: historico_tarea (table: voluntarios_historico)
ALTER TABLE voluntarios_historico ADD CONSTRAINT historico_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES voluntarios_tarea (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: historico_voluntario (table: voluntarios_historico)
ALTER TABLE voluntarios_historico ADD CONSTRAINT historico_voluntario
    FOREIGN KEY (nro_voluntario)
    REFERENCES voluntarios_voluntario (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: institucion_direccion (table: voluntarios_institucion)
ALTER TABLE voluntarios_institucion ADD CONSTRAINT institucion_direccion
    FOREIGN KEY (id_direccion)
    REFERENCES voluntarios_direccion (id_direccion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: institucion_voluntario (table: voluntarios_institucion)
ALTER TABLE voluntarios_institucion ADD CONSTRAINT institucion_voluntario
    FOREIGN KEY (id_director)
    REFERENCES voluntarios_voluntario (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: pais_continente (table: voluntarios_pais)
ALTER TABLE voluntarios_pais ADD CONSTRAINT pais_continente
    FOREIGN KEY (id_continente)
    REFERENCES voluntarios_continente (id_continente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: voluntario_institucion (table: voluntarios_voluntario)
ALTER TABLE voluntarios_voluntario ADD CONSTRAINT voluntario_institucion
    FOREIGN KEY (id_institucion)
    REFERENCES voluntarios_institucion (id_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: voluntario_tarea (table: voluntarios_voluntario)
ALTER TABLE voluntarios_voluntario ADD CONSTRAINT voluntario_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES voluntarios_tarea (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: voluntario_voluntario (table: voluntarios_voluntario)
ALTER TABLE voluntarios_voluntario ADD CONSTRAINT voluntario_voluntario
    FOREIGN KEY (id_coordinador)
    REFERENCES voluntarios_voluntario (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

