-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-12 14:05:59.928

-- tables
-- Table: peliculas_ciudad
CREATE TABLE peliculas_ciudad (
    id_ciudad decimal(6,0)  NOT NULL,
    nombre_ciudad varchar(100)  NOT NULL,
    id_pais char(2)  NOT NULL,
    CONSTRAINT FK_CIUDAD UNIQUE (id_pais) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_ciudad_pk PRIMARY KEY (id_ciudad)
);

-- Table: peliculas_departamento
CREATE TABLE peliculas_departamento (
    id_departamento decimal(4,0)  NOT NULL,
    id_distribuidor decimal(5,0)  NOT NULL,
    nombre_departamento varchar(30)  NOT NULL,
    calle varchar(40)  NULL,
    numero decimal(6,0)  NULL,
    id_ciudad decimal(6,0)  NOT NULL,
    jefe_departamento int  NOT NULL,
    CONSTRAINT FK_DEPARTAMENTO UNIQUE (id_ciudad, id_departamento) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_departamento_pk PRIMARY KEY (id_distribuidor,id_departamento)
);

-- Table: peliculas_distribuidor
CREATE TABLE peliculas_distribuidor (
    id_distribuidor decimal(5,0)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    direccion varchar(120)  NOT NULL,
    telefono varchar(20)  NULL,
    tipo char(1)  NOT NULL,
    CONSTRAINT peliculas_distribuidor_pk PRIMARY KEY (id_distribuidor)
);

-- Table: peliculas_empleado
CREATE TABLE peliculas_empleado (
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
    CONSTRAINT peliculas_empleado_pk PRIMARY KEY (id_empleado)
);

-- Table: peliculas_empresa_productora
CREATE TABLE peliculas_empresa_productora (
    codigo_productora varchar(6)  NOT NULL,
    nombre_productora varchar(60)  NOT NULL,
    id_ciudad decimal(6,0)  NULL,
    CONSTRAINT FK_EMPRESA_PRODUCTORA UNIQUE (id_ciudad) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_empresa_productora_pk PRIMARY KEY (codigo_productora)
);

-- Table: peliculas_entrega
CREATE TABLE peliculas_entrega (
    nro_entrega decimal(10,0)  NOT NULL,
    fecha_entrega decimal(10,0)  NOT NULL,
    id_video decimal(5,0)  NOT NULL,
    id_distribuidor decimal(5,0)  NOT NULL,
    CONSTRAINT FK_ENTREGA UNIQUE (id_distribuidor, id_video) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_entrega_pk PRIMARY KEY (nro_entrega)
);

-- Table: peliculas_internacional
CREATE TABLE peliculas_internacional (
    id_distribuidor decimal(5,0)  NOT NULL,
    codigo_pais varchar(5)  NOT NULL,
    CONSTRAINT FK_INTERNACIONAL UNIQUE (id_distribuidor) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_internacional_pk PRIMARY KEY (id_distribuidor)
);

-- Table: peliculas_nacional
CREATE TABLE peliculas_nacional (
    id_distribuidor decimal(5,0)  NOT NULL,
    nro_inscripcion decimal(8,0)  NOT NULL,
    encargadpo varchar(60)  NOT NULL,
    id_distrib_mayorista int  NULL,
    CONSTRAINT FK_NACIONAL UNIQUE (id_distrib_mayorista, id_distribuidor) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_nacional_pk PRIMARY KEY (id_distribuidor)
);

-- Table: peliculas_pais
CREATE TABLE peliculas_pais (
    id_pais char(2)  NOT NULL,
    nombre_pais varchar(40)  NOT NULL,
    CONSTRAINT peliculas_pais_pk PRIMARY KEY (id_pais)
);

-- Table: peliculas_pelicula
CREATE TABLE peliculas_pelicula (
    codigo_pelicula decimal(5,0)  NOT NULL,
    titulo varchar(60)  NOT NULL,
    idioma varchar(20)  NOT NULL,
    formato varchar(20)  NOT NULL,
    genero varchar(30)  NOT NULL,
    codigo_productora varchar(6)  NOT NULL,
    CONSTRAINT FK_PELICULA UNIQUE (codigo_productora) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_pelicula_pk PRIMARY KEY (codigo_pelicula)
);

-- Table: peliculas_renglon_entrega
CREATE TABLE peliculas_renglon_entrega (
    nro_entrega decimal(10,0)  NOT NULL,
    codigo_pelicula decimal(5,0)  NOT NULL,
    cantidad decimal(5,0)  NOT NULL,
    CONSTRAINT FK_RENGLON_ENTREGA UNIQUE (codigo_pelicula) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT peliculas_renglon_entrega_pk PRIMARY KEY (nro_entrega,codigo_pelicula)
);

-- Table: peliculas_tarea
CREATE TABLE peliculas_tarea (
    id_tarea varchar(10)  NOT NULL,
    nombre_tarea varchar(35)  NOT NULL,
    sueldo_maximo decimal(6,0)  NOT NULL,
    sueldo_minimo decimal(6,0)  NOT NULL,
    CONSTRAINT peliculas_tarea_pk PRIMARY KEY (id_tarea)
);

-- Table: peliculas_video
CREATE TABLE peliculas_video (
    id_video decimal(5,0)  NOT NULL,
    razon_social varchar(60)  NOT NULL,
    direccion varchar(80)  NOT NULL,
    telefono varchar(15)  NULL,
    propietario varchar(60)  NOT NULL,
    CONSTRAINT peliculas_video_pk PRIMARY KEY (id_video)
);

-- foreign keys
-- Reference: ciudad_pais (table: peliculas_ciudad)
ALTER TABLE peliculas_ciudad ADD CONSTRAINT ciudad_pais
    FOREIGN KEY (id_pais)
    REFERENCES peliculas_pais (id_pais)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: departamento_ciudad (table: peliculas_departamento)
ALTER TABLE peliculas_departamento ADD CONSTRAINT departamento_ciudad
    FOREIGN KEY (id_ciudad)
    REFERENCES peliculas_ciudad (id_ciudad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: departamento_distribuidor (table: peliculas_departamento)
ALTER TABLE peliculas_departamento ADD CONSTRAINT departamento_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES peliculas_distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: departamento_empleado (table: peliculas_departamento)
ALTER TABLE peliculas_departamento ADD CONSTRAINT departamento_empleado
    FOREIGN KEY (jefe_departamento)
    REFERENCES peliculas_empleado (id_empleado)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: empleado_departamento (table: peliculas_empleado)
ALTER TABLE peliculas_empleado ADD CONSTRAINT empleado_departamento
    FOREIGN KEY (id_distribuidor, id_departamento)
    REFERENCES peliculas_departamento (id_distribuidor, id_departamento)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: empleado_empleado (table: peliculas_empleado)
ALTER TABLE peliculas_empleado ADD CONSTRAINT empleado_empleado
    FOREIGN KEY (id_jefe)
    REFERENCES peliculas_empleado (id_jefe)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: empleado_tarea (table: peliculas_empleado)
ALTER TABLE peliculas_empleado ADD CONSTRAINT empleado_tarea
    FOREIGN KEY (id_tarea)
    REFERENCES peliculas_tarea (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: entrega_distribuidor (table: peliculas_entrega)
ALTER TABLE peliculas_entrega ADD CONSTRAINT entrega_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES peliculas_distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: entrega_video (table: peliculas_entrega)
ALTER TABLE peliculas_entrega ADD CONSTRAINT entrega_video
    FOREIGN KEY (id_video)
    REFERENCES peliculas_video (id_video)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: internacional_distribuidor (table: peliculas_internacional)
ALTER TABLE peliculas_internacional ADD CONSTRAINT internacional_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES peliculas_distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: nacional_distribuidor (table: peliculas_nacional)
ALTER TABLE peliculas_nacional ADD CONSTRAINT nacional_distribuidor
    FOREIGN KEY (id_distribuidor)
    REFERENCES peliculas_distribuidor (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: nacional_internacional (table: peliculas_nacional)
ALTER TABLE peliculas_nacional ADD CONSTRAINT nacional_internacional
    FOREIGN KEY (id_distribuidor)
    REFERENCES peliculas_internacional (id_distribuidor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: pelicula_productora (table: peliculas_pelicula)
ALTER TABLE peliculas_pelicula ADD CONSTRAINT pelicula_productora
    FOREIGN KEY (codigo_productora)
    REFERENCES peliculas_empresa_productora (codigo_productora)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: productora_ciudad (table: peliculas_empresa_productora)
ALTER TABLE peliculas_empresa_productora ADD CONSTRAINT productora_ciudad
    FOREIGN KEY (id_ciudad)
    REFERENCES peliculas_ciudad (id_ciudad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: renglon_entrega_entrega (table: peliculas_renglon_entrega)
ALTER TABLE peliculas_renglon_entrega ADD CONSTRAINT renglon_entrega_entrega
    FOREIGN KEY (nro_entrega)
    REFERENCES peliculas_entrega (nro_entrega)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: renglon_entrega_pelicula (table: peliculas_renglon_entrega)
ALTER TABLE peliculas_renglon_entrega ADD CONSTRAINT renglon_entrega_pelicula
    FOREIGN KEY (codigo_pelicula)
    REFERENCES peliculas_pelicula (codigo_pelicula)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

