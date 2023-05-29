--1. Cree una consulta para mostrar el identificador de profesor, apellido y nombre de aquellos profesores que dictan
-- entre 2 y 4 asignaturas,
-- teniendo en cuenta sólo aquellas asignaturas que tienen una cantidad de horas de teoría (CantHsT) mayor a 40.

SELECT nombre || apellido "Nombre y Apellido", p.tipo_documento || p.nro_documento "Tipo y nro documento", a.cod_asignatura
FROM ej_1_profesor p INNER JOIN ej_1_asignatura_profesor ap
ON (p.tipo_documento=ap.tipo_documento AND p.nro_documento=ap.nro_documento)
INNER JOIN ej_1_asignatura a ON a.cod_asignatura=ap.cod_asignatura  WHERE cant_hs_t=40 GROUP BY nombre, apellido, p.tipo_documento, p.nro_documento, a.cod_asignatura
 HAVING COUNT(DISTINCT a.cod_asignatura) BETWEEN 2 AND 4;

--2. Plantee el recurso declarativo más adecuado que controle que un profesor exclusivo
-- tenga título de “Ingeniero” Indique qué tipo de restricción es y si es o no soportada por PostgreSQL.
ALTER TABLE ej_1_profesor ADD CONSTRAINT ck_prof_exclusivo_ingeniero CHECK ((tipo_prof=1 AND titulo='Ingeniero') OR tipo_prof=0);




