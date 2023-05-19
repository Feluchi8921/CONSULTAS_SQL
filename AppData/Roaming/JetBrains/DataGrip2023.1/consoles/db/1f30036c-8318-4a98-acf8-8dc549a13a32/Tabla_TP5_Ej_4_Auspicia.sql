-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-10 12:26:31.79

-- tables
-- Table: Auspicia
CREATE TABLE Auspicia (
    cod_ausp char(3)  NOT NULL,
    nro_auto int  NOT NULL,
    id_equipo int  NOT NULL
);

-- Table: Auspiciante
CREATE TABLE Auspiciante (
    cod_ausp char(3)  NOT NULL,
    nombre varchar(50)  NOT NULL,
    tipo varchar(30)  NOT NULL,
    CONSTRAINT Auspiciante_pk PRIMARY KEY (cod_ausp)
);

-- Table: Auto
CREATE TABLE Auto (
    id_equipo int  NOT NULL,
    nro_auto int  NOT NULL,
    conductor varchar(50)  NOT NULL,
    copiloto varchar(50)  NOT NULL,
    CONSTRAINT Auto_pk PRIMARY KEY (nro_auto,id_equipo)
);

-- Table: Desemp_Etapa
CREATE TABLE Desemp_Etapa (
    netapa int  NOT NULL,
    id_equipo int  NOT NULL,
    nro_auto int  NOT NULL
);

-- Table: Equipo
CREATE TABLE Equipo (
    id_equipo int  NOT NULL,
    nombre_equipo varchar(25)  NOT NULL,
    contacto varchar(50)  NOT NULL,
    pais varchar(50)  NOT NULL,
    cat_partic int  NOT NULL,
    CONSTRAINT Equipo_pk PRIMARY KEY (id_equipo)
);

-- Table: Etapa
CREATE TABLE Etapa (
    netapa int  NOT NULL,
    id_equipo int  NOT NULL,
    nro_auto int  NOT NULL,
    ciudad_salida varchar(35)  NOT NULL,
    ciudad_llegada varchar(35)  NOT NULL,
    km_etapa int  NOT NULL,
    tipo_terreno varchar(35)  NOT NULL,
    CONSTRAINT Etapa_pk PRIMARY KEY (netapa)
);

-- foreign keys
-- Reference: Auspicia_Auspiciante (table: Auspicia)
ALTER TABLE Auspicia ADD CONSTRAINT Auspicia_Auspiciante
    FOREIGN KEY (cod_ausp)
    REFERENCES Auspiciante (cod_ausp)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Auspicia_Auto (table: Auspicia)
ALTER TABLE Auspicia ADD CONSTRAINT Auspicia_Auto
    FOREIGN KEY (nro_auto, id_equipo)
    REFERENCES Auto (nro_auto, id_equipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Auto_Equipo (table: Auto)
ALTER TABLE Auto ADD CONSTRAINT Auto_Equipo
    FOREIGN KEY (id_equipo)
    REFERENCES Equipo (id_equipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Desemp_Etapa_Auto (table: Desemp_Etapa)
ALTER TABLE Desemp_Etapa ADD CONSTRAINT Desemp_Etapa_Auto
    FOREIGN KEY (nro_auto, id_equipo)
    REFERENCES Auto (nro_auto, id_equipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Desemp_Etapa_Etapa (table: Desemp_Etapa)
ALTER TABLE Desemp_Etapa ADD CONSTRAINT Desemp_Etapa_Etapa
    FOREIGN KEY (netapa)
    REFERENCES Etapa (netapa)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: Etapa_Auto (table: Etapa)
ALTER TABLE Etapa ADD CONSTRAINT Etapa_Auto
    FOREIGN KEY (nro_auto, id_equipo)
    REFERENCES Auto (nro_auto, id_equipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

