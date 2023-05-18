--1. En base al esquema de películas, cuáles son los 3 primeros nombres de distribuidores por orden alfabético
-- de aquellos departamentos cuyo jefe tiene porcentaje superior al 20%, y cuyos empleados (del departamento)
-- tienen registrado su teléfono con característica ‘600’.
SELECT dist.nombre FROM unc_esq_peliculas.distribuidor dist INNER JOIN unc_esq_peliculas.departamento dep ON dist.id_distribuidor=dep.id_distribuidor = dep.id_distribuidor
INNER JOIN unc_esq_peliculas.empleado e ON (dep.id_departamento=dist.id_distribuidor AND dep.id_distribuidor=e.id_distribuidor) WHERE

--Primero uno las relaciones empleado con depto y luego empleado con jefe
SELECT * FROM unc_esq_peliculas.empleado e INNER JOIN unc_esq_peliculas.departamento dpto ON
    (e.id_departamento=dpto.id_departamento AND e.id_distribuidor=dpto.id_distribuidor) INNER JOIN unc_esq_peliculas.empleado j
ON (dpto.jefe_departamento=e.id_empleado) WHERE (j.porc_comision>20 AND e.telefono LIKE '600%');

