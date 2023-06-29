CREATE VIEW Distribuidor_200  AS
SELECT id_distribuidor, nombre, tipo
FROM esq_peliculas_distribuidor
WHERE id_distribuidor > 200;

CREATE VIEW Departamento_dist_200 AS
SELECT id_departamento, nombre, id_ciudad, jefe_departamento
FROM esq_peliculas_departamento
WHERE id_distribuidor > 200;

CREATE VIEW Distribuidor_1000  AS
SELECT *
FROM esq_peliculas_distribuidor
WHERE id_distribuidor > 1000;

INSERT INTO Distribuidor_1000 VALUES (20005, 'NuevoDistribuidor 1050', 'Montiel 340', '569842-2643', 'N');
SELECT * FROM Distribuidor_1000 WHERE id_distribuidor=20005;

--Pruebo si se actualizo la tabla
SELECT * FROM esq_peliculas_distribuidor WHERE id_distribuidor=20005;
SELECT * FROM Distribuidor_200;
SELECT * FROM Departamento_dist_200;

--1. Cree una vista EMPLEADO_DIST que liste el nombre, apellido, sueldo, y fecha_nacimiento de los empleados
-- que pertenecen al distribuidor cuyo identificador es 20.
CREATE VIEW EMPLEADO_DIST AS
SELECT e.nombre, e.apellido, e.sueldo, e.fecha_nacimiento
FROM unc_esq_peliculas.empleado e
INNER JOIN unc_esq_peliculas.empleado d ON e.id_empleado=d.id_empleado
WHERE d.id_distribuidor=20;

SELECT * FROM EMPLEADO_DIST;

--2. Sobre la vista anterior defina otra vista EMPLEADO_DIST_2000
-- con el nombre, apellido y sueldo de los empleados que cobran más de 2000.

CREATE VIEW EMPLEADO_DIST_2000 AS
SELECT nombre, apellido, sueldo
FROM EMPLEADO_DIST
WHERE sueldo>2000;

SELECT * FROM EMPLEADO_DIST_2000;

--3. Sobre la vista EMPLEADO_DIST cree la vista EMPLEADO_DIST_20_70 con aquellos empleados
-- que han nacido en la década del 70 (entre los años 1970 y 1979).
CREATE VIEW EMPLEADO_DIST_20_70 AS
SELECT *
FROM EMPLEADO_DIST
WHERE EXTRACT(YEARS FROM fecha_nacimiento)
BETWEEN 1970 AND 1979;

SELECT * FROM EMPLEADO_DIST_20_70;

--4.Cree una vista PELICULAS_ENTREGADA que contenga el código de la película y la cantidad de unidades entregadas.
CREATE VIEW PELICULAS_ENTREGADA AS
SELECT codigo_pelicula, cantidad
FROM unc_esq_peliculas.renglon_entrega;

SELECT * FROM PELICULAS_ENTREGADA;

--5. Cree una vista ACCION_2000 con el código, el titulo el idioma y el formato
-- de las películas del género ‘Acción’ entregadas en el año 2006.
CREATE VIEW ACCION_2000 AS
SELECT p.codigo_pelicula, titulo, idioma, formato
FROM unc_esq_peliculas.pelicula p INNER JOIN unc_esq_peliculas.renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
INNER JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
WHERE genero='Acción' AND EXTRACT(YEARS FROM fecha_entrega)=2006;

SELECT * FROM ACCION_2000;

--6. Cree una vista DISTRIBUIDORAS_ARGENTINA con los datos completos de las distribuidoras nacionales y sus respectivos departamentos.
CREATE VIEW DISTRIBUDIRAS_ARGENTINA AS
SELECT d.id_distribuidor, d.nombre, d.direccion, d.telefono, d.tipo, dpto.id_departamento
FROM unc_esq_peliculas.distribuidor d INNER JOIN unc_esq_peliculas.departamento dpto ON d.id_distribuidor = dpto.id_distribuidor
WHERE tipo='N';

SELECT * FROM DISTRIBUDIRAS_ARGENTINA;

--7.De la vista anterior cree la vista Distribuidoras_mas_2_emp con los datos completos
-- de las distribuidoras cuyos departamentos tengan más de 2 empleados.

CREATE VIEW Distribuidoras_mas_2_emp AS
SELECT d.id_distribuidor, d.nombre, d.direccion, d.telefono, d.tipo
FROM peliculas_distribuidor d
    INNER JOIN peliculas_departamento dpto
        ON d.id_distribuidor = dpto.id_distribuidor
INNER JOIN unc_esq_peliculas.empleado e
    ON e.id_departamento=dpto.id_departamento
           AND e.id_distribuidor=dpto.id_distribuidor
GROUP BY d.id_distribuidor, d.nombre, d.direccion, d.telefono, d.tipo HAVING
  COUNT(DISTINCT dpto.id_distribuidor) > 2;


--Ejercicio 3

--Analice cuáles serían los controles y el comportamiento antes de las actualizaciones en las vistas
-- EMPLEADO_DIST, EMPLEADO_DIST_2000 y EMPLEADO_DIST_20_70 creadas en el ejercicio2,
-- si se definen con CON CHEQUE OPCIÓN LOCAL o CASCADA en cada uno de ellos. Evalúa todas las alternativas.
CREATE VIEW EMPLEADO_DIST_2 AS
SELECT e.nombre, e.apellido, e.sueldo, e.fecha_nacimiento
FROM esq_peliculas_empleado e
INNER JOIN esq_peliculas_empleado d ON e.id_empleado=d.id_empleado
WHERE d.id_distribuidor=20;

CREATE VIEW EMPLEADO_DIST_2000_2 AS
SELECT nombre, apellido, sueldo
FROM EMPLEADO_DIST
WHERE sueldo>2000
WITH LOCAL CHECK OPTION
;
--Hago la prueba y no trae registros porque no tengo la PK

INSERT INTO esq_peliculas_empleado
    (id_empleado, nombre, apellido, porc_comision, sueldo, e_mail, fecha_nacimiento, telefono, id_tarea, id_departamento, id_distribuidor, id_jefe)
VALUES (300000, 'Felicitas', 'Aguerralde', 2000, 30000, 'felu', '1989-03-21', 2494026987, 6487, 75, 219, 7944);

SELECT * FROM EMPLEADO_DIST_2 WHERE nombre='Felicitas';

CREATE VIEW EMPLEADO_DIST_2 AS
SELECT e.nombre, e.apellido, e.sueldo, e.fecha_nacimiento
FROM esq_peliculas_empleado e
INNER JOIN esq_peliculas_empleado d ON e.id_empleado=d.id_empleado
WHERE d.id_distribuidor=20;

CREATE VIEW EMPLEADO_DIST_2000_3 AS
SELECT nombre, apellido, sueldo
FROM EMPLEADO_DIST
WHERE sueldo>2000
WITH CASCADED CHECK OPTION
;

INSERT INTO esq_peliculas_empleado
    (id_empleado, nombre, apellido, porc_comision, sueldo, e_mail, fecha_nacimiento, telefono, id_tarea, id_departamento, id_distribuidor, id_jefe)
VALUES (300001, 'Felicitas', 'Aguerralde', 2000, 30000, 'felu', '1989-03-21', 2494026987, 6487, 75, 219, 7944);

SELECT * FROM EMPLEADO_DIST_2000_3 WHERE nombre='Felicitas';

--Hago la prueba y no trae registros porque no tengo la PK

------------------------------Ejemplos vistas actualizables------------------------------------------
DROP TABLE IF EXISTS PROOVEDOR CASCADE;
DROP TABLE IF EXISTS ARTICULO CASCADE;
DROP TABLE IF EXISTS ENVIO CASCADE;

CREATE TABLE PROVEEDOR(
    id_proveedor int NOT NULL ,
    apellido varchar(40),
    rubro varchar(40),
    ciudad varchar(20),
    primary key (id_proveedor)
);
CREATE TABLE ARTICULO(
    id_articulo int NOT NULL,
    descripcion VARCHAR(30),
    peso int,
    primary key(id_articulo)
);

CREATE TABLE ENVIO(
    id_proveedor int NOT NULL,
    id_articulo int NOT NULL,
    cantidad int,
    PRIMARY KEY (id_proveedor, id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor),
    FOREIGN KEY (id_articulo) REFERENCES ARTICULO(id_articulo)
);
--Prueba1
CREATE VIEW PROV_TANDIL1 AS
    SELECT id_proveedor, apellido
    FROM PROVEEDOR WHERE ciudad='Tandil';

INSERT INTO PROVEEDOR (id_proveedor, apellido, rubro, ciudad) VALUES (5, 'Alvarez', 'almacen', 'Mar del Plata');
--no se inserta porque no cumple con el where
INSERT INTO PROVEEDOR (id_proveedor, apellido, rubro, ciudad) VALUES (6, 'Alvarez', 'almacen', 'Tandil');
--se inserta porque tengo el id_proveedor en la vista y es pk, ademas cumple con el where
SELECT * FROM PROV_TANDIL1;

--Prueba2
CREATE VIEW PROV_COMP
AS SELECT apellido, ciudad
FROM PROVEEDOR WHERE rubro='almacen';

INSERT INTO PROVEEDOR (id_proveedor, apellido, rubro, ciudad) VALUES (7, 'Perez', 'almacen', 'Tandil');

SELECT * FROM PROV_COMP;

--Anduvo

--Prueba3
CREATE VIEW PRUEBA
AS SELECT apellido
FROM PROV_COMP WHERE apellido='Aguerralde';

INSERT INTO PROVEEDOR (id_proveedor, apellido, rubro, ciudad) VALUES (8, 'Aguerralde', 'automotor', 'Tandil');
SELECT * FROM PRUEBA;
--No trae nada, porque la tabla anterior no tiene la pk
INSERT INTO PROV_COMP (apellido) VALUES ('Sarasa');
--viola el id_proveedor no nulo

--Prueba4
CREATE VIEW TOTAL_ARTICULO
AS SELECT id_articulo, sum(cantidad)
FROM ENVIO
GROUP BY id_articulo;

SELECT * FROM TOTAL_ARTICULO;

INSERT INTO ENVIO (id_proveedor, id_articulo, cantidad) VALUES (4, 2, 10);

--Se actualizo porque tengo la pk

CREATE VIEW EN_CASCADA AS
    SELECT ciudad FROM PROVEEDOR
    WHERE ciudad='Mar del Plata'
WITH CASCADED CHECK OPTION;

INSERT INTO PROVEEDOR (id_proveedor, apellido, rubro, ciudad) VALUES (10, 'Suarez', 'camionero', 'Mar del Plata');
SELECT * FROM EN_CASCADA;

--EN CASCADED SI SE ACTUALIZA LA TABLA ORIGINAL TMB SE ACTUALIZA LA VISTA

CREATE VIEW EN_LOCAL AS
    SELECT apellido, rubro FROM PROVEEDOR
    WHERE rubro='Camionero'
WITH LOCAL CHECK OPTION;

DROP VIEW IF EXISTS EN_LOCAL;

INSERT INTO PROVEEDOR (id_proveedor, apellido, rubro, ciudad) VALUES (15, 'que onda', 'Camionero', 'Mar del Plata');
SELECT * FROM EN_LOCAL;

--SE ACTUALIZA PORQUE LAS FILAS EXISTEN EN LA VISTA