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