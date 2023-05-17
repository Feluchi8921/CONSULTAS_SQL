-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 23:11:03.915

-- tables
-- Table: P5P2E5_CLIENTE
CREATE TABLE P5P2E5_CLIENTE (
    id_cliente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    estado char(5)  NOT NULL,
    CONSTRAINT PK_P5P2E5_CLIENTE PRIMARY KEY (id_cliente)
);

-- Table: P5P2E5_FECHA_LIQ
CREATE TABLE P5P2E5_FECHA_LIQ (
    dia_liq int  NOT NULL,
    mes_liq int  NOT NULL,
    cant_dias int  NOT NULL,
    CONSTRAINT PK_P5P2E5_FECHA_LIQ PRIMARY KEY (dia_liq,mes_liq)
);

-- Table: P5P2E5_PRENDA
CREATE TABLE P5P2E5_PRENDA (
    id_prenda int  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    descripcion varchar(120)  NOT NULL,
    tipo varchar(40)  NOT NULL,
    categoria varchar(80)  NOT NULL,
    CONSTRAINT PK_P5P2E5_PRENDA PRIMARY KEY (id_prenda)
);

-- Table: P5P2E5_VENTA
CREATE TABLE P5P2E5_VENTA (
    id_venta int  NOT NULL,
    descuento decimal(10,2)  NOT NULL,
    fecha timestamp  NOT NULL,
    id_prenda int  NOT NULL,
    id_cliente int  NOT NULL,
    CONSTRAINT PK_P5P2E5_VENTA PRIMARY KEY (id_venta)
);

-- foreign keys
-- Reference: FK_P5P2E5_VENTA_CLIENTE (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES P5P2E5_CLIENTE (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E5_VENTA_PRENDA (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_PRENDA
    FOREIGN KEY (id_prenda)
    REFERENCES P5P2E5_PRENDA (id_prenda)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.
--Consultas:
--Primero inserto algunos datos
INSERT INTO p5p2e5_prenda (id_prenda, precio, descripcion, tipo, categoria) VALUES (4, 4500, 'gorro', 'lana', 'oferta');
select * from p5p2e5_prenda;
INSERT INTO p5p2e5_cliente (id_cliente, apellido, nombre, estado) VALUES (3, 'Luguercio', 'Sebastian', 'a');
INSERT INTO p5p2e5_venta (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES (5, 0,'2022-02-12 10:20:15', 4, 2);
INSERT INTO p5p2e5_fecha_liq (dia_liq, mes_liq, cant_dias) VALUES (20,12,3);


--Consulto el tipo de dato de fecha
Select  * from information_schema.columns WHERE TABLE_NAME='p5p2e5_venta' AND COLUMN_NAME='fecha';

--5.a. Los descuentos en las ventas son porcentajes y deben estar entre  0 y 100.
ALTER TABLE p5p2e5_venta ADD CONSTRAINT ck_venta_descuento_0_100 CHECK (descuento BETWEEN 0 AND 100);

--5.c. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
ALTER TABLE p5p2e5_fecha_liq ADD CONSTRAINT ck_fecha_liq_mes_7_12_dias_menor_5 CHECK
    (NOT EXISTS(SELECT * FROM p5p2e5_fecha_liq WHERE ((mes_liq=7 OR mes_liq=12) AND  cant_dias>5)));
--subconsulta:
SELECT * FROM p5p2e5_fecha_liq WHERE ((mes_liq=7 OR mes_liq=12) AND  cant_dias>5);

--5.d. Las prendas de categoría ‘oferta’ no tienen descuentos.
CREATE ASSERTION ck_venta_prenda_categoria_oferta_sin_descuento CHECK
    (NOT EXISTS (SELECT * FROM p5p2e5_venta v INNER JOIN p5p2e5_prenda p ON v.id_prenda = p.id_prenda  WHERE
    (categoria='oferta' AND descuento!=0)));
--subconsulta en negacion
    SELECT * FROM p5p2e5_venta v INNER JOIN p5p2e5_prenda p ON v.id_prenda = p.id_prenda  WHERE
    (categoria='oferta' AND descuento!=0);