-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-12 13:39:48.087

-- tables
-- Table: ciudad
CREATE TABLE ciudad (
    id_ciudad decimal(6,0)  NOT NULL,
    nombre_ciudad varchar(100)  NOT NULL,
    id_pais char(2)  NOT NULL,
    CONSTRAINT FK_CIUDAD UNIQUE (id_pais) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT ciudad_pk PRIMARY KEY (id_ciudad)
);

-- Table: departamento
CREATE TABLE departamento (
    id_departamento decimal(4,0)  NOT NULL,
    id_distribuidor decimal(5,0)  NOT NULL,
    nombre_departamento varchar(30)  NOT NULL,
    calle varchar(40)  NULL,
    numero decimal(6,0)  NULL,
    id_ciudad decimal(6,0)  NOT NULL,
    jefe_departamento int  NOT NULL,
    CONSTRAINT FK_DEPARTAMENTO UNIQUE (id_ciudad, id_departamento) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT departamento_pk PRIMARY KEY (id_distribuidor,id_departamento)
);

-- Table: distribuidor
CREATE TABLE distribuidor (
    id_distribuidor decimal(5,0)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    direccion varchar(120)  NOT NULL,
    telefono varchar(20)  NULL,
    tipo char(1)  NOT NULL,
    CONSTRAINT distribuidor_pk PRIMARY KEY (id_distribuidor)
);

-- Table: empleado
CREATE TABLE empleado (
    id_empleado int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    porc_comision decimal(6,2)  NULL,
    sueldo decimal(8,2)  NULL,
    e_mail varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL,
    telefono varchar(20)  NULL,
    id_tarea varchar(10)  NOT NULL,
    id_jefe decimal(6,0)  NULL,
    id_distribuidor decimal(5,0)  NOT NULL,
    id_departamento decimal(4,0)  NOT NULL,
    CONSTRAINT FK_EMPLEADO UNIQUE (id_jefe) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT empleado_pk PRIMARY KEY (id_empleado)
);

-- Table: empresa_productora
CREATE TABLE empresa_productora (
    codigo_productora varchar(6)  NOT NULL,
    nombre_productora varchar(60)  NOT NULL,
    id_ciudad decimal(6,0)  NULL,
    CONSTRAINT FK_EMPRESA_PRODUCTORA UNIQUE (id_ciudad) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT empresa_productora_pk PRIMARY KEY (codigo_productora)
);

-- Table: entrega
CREATE TABLE entrega (
    nro_entrega decimal(10,0)  NOT NULL,
    fecha_entrega decimal(10,0)  NOT NULL,
    id_video decimal(5,0)  NOT NULL,
    id_distribuidor decimal(5,0)  NOT NULL,
    CONSTRAINT FK_ENTREGA UNIQUE (id_distribuidor, id_video) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT entrega_pk PRIMARY KEY (nro_entrega)
);

-- Table: internacional
CREATE TABLE internacional (
    id_distribuidor decimal(5,0)  NOT NULL,
    codigo_pais varchar(5)  NOT NULL,
    CONSTRAINT FK_INTERNACIONAL UNIQUE (id_distribuidor) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT internacional_pk PRIMARY KEY (id_distribuidor)
);

-- Table: nacional
CREATE TABLE nacional (
    id_distribuidor decimal(5,0)  NOT NULL,
    nro_inscripcion decimal(8,0)  NOT NULL,
    encargadpo varchar(60)  NOT NULL,
    id_distrib_mayorista int  NULL,
    CONSTRAINT FK_NACIONAL UNIQUE (id_distrib_mayorista, id_distribuidor) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT nacional_pk PRIMARY KEY (id_distribuidor)
);

-- Table: pais
CREATE TABLE pais (
    id_pais char(2)  NOT NULL,
    nombre_pais varchar(40)  NOT NULL,
    CONSTRAINT pais_pk PRIMARY KEY (id_pais)
);

-- Table: pelicula
CREATE TABLE pelicula (
    codigo_pelicula decimal(5,0)  NOT NULL,
    titulo varchar(60)  NOT NULL,
    idioma varchar(20)  NOT NULL,
    formato varchar(20)  NOT NULL,
    genero varchar(30)  NOT NULL,
    codigo_productora varchar(6)  NOT NULL,
    CONSTRAINT FK_PELICULA UNIQUE (codigo_productora) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT pelicula_pk PRIMARY KEY (codigo_pelicula)
);

-- Table: renglon_entrega
CREATE TABLE renglon_entrega (
    nro_entrega decimal(10,0)  NOT NULL,
    codigo_pelicula decimal(5,0)  NOT NULL,
    cantidad decimal(5,0)  NOT NULL,
    CONSTRAINT FK_RENGLON_ENTREGA UNIQUE (codigo_pelicula) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT renglon_entrega_pk PRIMARY KEY (nro_entrega,codigo_pelicula)
);

-- Table: tarea
CREATE TABLE tarea (
    id_tarea varchar(10)  NOT NULL,
    nombre_tarea varchar(35)  NOT NULL,
    sueldo_maximo decimal(6,0)  NOT NULL,
    sueldo_minimo decimal(6,0)  NOT NULL,
    CONSTRAINT tarea_pk PRIMARY KEY (id_tarea)
);

-- Table: video
CREATE TABLE video (
    id_video decimal(5,0)  NOT NULL,
    razon_social varchar(60)  NOT NULL,
    direccion varchar(80)  NOT NULL,
    telefono varchar(15)  NULL,
    propietario varchar(60)  NOT NULL,
    CONSTRAINT video_pk PRIMARY KEY (id_video)
);

-- foreign keys
-- Reference: ciudad_pais (table: ciudad)
ALTER TABLE ciudad ADD CONSTRAINT ciudad_pais
    FOREIGN KEY (id_pais)
    REFERENCES pais (id_pais)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: departamento_ciudad (table: departamento)
ALTER TABLE departamento ADD CONSTRAINT departamento_ciudad
    FOREIGN KEY (id_ciudad)
    REFERENCES ciudad (id_ciudad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: departamento_distribuidor (table: departamento)
ALTER TABLE departamento ADD CONSTRAINT departamento_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: departamento_empleado (table: departamento)
ALTER TABLE departamento ADD CONSTRAINT departamento_empleado
    FOREIGN KEY (jefe_departamento)
    REFERENCES empleado (id_empleado)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: empleado_departamento (table: empleado)
ALTER TABLE empleado ADD CONSTRAINT empleado_departamento
    FOREIGN KEY (id_distribuidor, id_departamento)
    REFERENCES departamento (id_distribuidor, id_departamento)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: empleado_empleado (table: empleado)
ALTER TABLE empleado ADD CONSTRAINT empleado_empleado
    FOREIGN KEY (id_jefe)
    REFERENCES empleado (id_jefe)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: empleado_tarea (table: empleado)
ALTER TABLE empleado ADD CONSTRAINT empleado_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES tarea (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: entrega_distribuidor (table: entrega)
ALTER TABLE entrega ADD CONSTRAINT entrega_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: entrega_video (table: entrega)
ALTER TABLE entrega ADD CONSTRAINT entrega_video
    FOREIGN KEY (id_video)
    REFERENCES video (id_video)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: internacional_distribuidor (table: internacional)
ALTER TABLE internacional ADD CONSTRAINT internacional_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: nacional_distribuidor (table: nacional)
ALTER TABLE nacional ADD CONSTRAINT nacional_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: nacional_internacional (table: nacional)
ALTER TABLE nacional ADD CONSTRAINT nacional_internacional
    FOREIGN KEY (id_distribuidor)
    REFERENCES internacional (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: pelicula_productora (table: pelicula)
ALTER TABLE pelicula ADD CONSTRAINT pelicula_productora
    FOREIGN KEY (codigo_productora)
    REFERENCES empresa_productora (codigo_productora)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: productora_ciudad (table: empresa_productora)
ALTER TABLE empresa_productora ADD CONSTRAINT productora_ciudad
    FOREIGN KEY (id_ciudad)
    REFERENCES ciudad (id_ciudad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: renglon_entrega_entrega (table: renglon_entrega)
ALTER TABLE renglon_entrega ADD CONSTRAINT renglon_entrega_entrega
    FOREIGN KEY (nro_entrega)
    REFERENCES entrega (nro_entrega)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: renglon_entrega_pelicula (table: renglon_entrega)
ALTER TABLE renglon_entrega ADD CONSTRAINT renglon_entrega_pelicula
    FOREIGN KEY (codigo_pelicula)
    REFERENCES pelicula (codigo_pelicula)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

