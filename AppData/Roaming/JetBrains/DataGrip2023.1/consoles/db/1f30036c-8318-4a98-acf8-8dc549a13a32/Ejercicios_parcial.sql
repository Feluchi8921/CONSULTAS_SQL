--1. En base al esquema de películas, cuáles son los 3 primeros nombres de distribuidores por orden alfabético
-- de aquellos departamentos cuyo jefe tiene porcentaje superior al 20%, y cuyos empleados (del departamento)
-- tienen registrado su teléfono con característica ‘600’.

SELECT j.nombre, j.apellido FROM unc_esq_peliculas.empleado e INNER JOIN unc_esq_peliculas.empleado j ON (e.id_empleado=j.id_jefe)
WHERE (j.porc_comision>0.2 AND e.telefono LIKE '%600') ORDER BY j.nombre ASC limit 3;

--2. En el esquema de voluntarios ¿cuál sería la consulta SOL que permite listar los id de los coordinadores
-- y la cantidad de voluntarios que cada uno coordina, sólo si estos voluntarios pertenecen a instituciones
-- que poseen director y si dicha cantidad es mayor que 5?
SELECT id_coordinador, COUNT(nro_voluntario) CANT_VOLUN FROM unc_esq_voluntario.voluntario v INNER JOIN unc_esq_voluntario.institucion i
ON (v.id_institucion=i.id_institucion) WHERE id_coordinador IS NOT NULL GROUP BY id_coordinador
HAVING COUNT(nro_voluntario)>5;

--3.Utilizando el esquema películas cual es el resultado correcto que indica las tres tareas que tienen
--  la menor diferencia entre sueldo maximo y minimo, y ademas que el sueldo máximo sea menor o igual a 11000.

SELECT id_tarea, (sueldo_maximo-tarea.sueldo_minimo) diferencia FROM unc_esq_peliculas.tarea
GROUP BY id_tarea, diferencia HAVING sueldo_maximo<=11000 ORDER BY diferencia ASC LIMIT 3;

--4. Utilizando el esquema de películas. Cuál es la sentencia SQL que me daría un
-- listado con el identificador de departamento y la cantidad de empleados en cada uno.
SELECT d.id_departamento, COUNT(id_empleado) FROM unc_esq_peliculas.departamento d INNER JOIN unc_esq_peliculas.empleado e
ON d.id_departamento=e.id_departamento GROUP BY d.id_departamento, id_empleado;

--5. Utilizando el esquema de películas. Cuál es la sentencia SQL que me darían un listado con los códigos de país y
-- la cantidad de ciudades en éste, teniendo en cuenta sólo los países cuyo nombre terminen en ‘IA’.
SELECT p.id_pais, p.nombre_pais, count(id_ciudad) FROM unc_esq_peliculas.ciudad c INNER JOIN unc_esq_peliculas.pais p ON p.id_pais = c.id_pais
GROUP BY p.id_pais, p.nombre_pais HAVING p.nombre_pais LIKE '%IA';

--6. Utilizando el esquema de películas. Cuál es la cantidad de distribuidoras internacionales y nacionales
-- en las cuales su teléfono termine con el número 2.
SELECT tipo, COUNT(*) FROM unc_esq_peliculas.distribuidor WHERE telefono LIKE '%2' GROUP BY tipo;
