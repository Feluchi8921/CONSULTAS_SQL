--3. En el esquema unc_esq_voluntario, ¿cuál sería la consulta SQL que permite listar los
-- id de los coordinadores y la cantidad de voluntarios que cada no coordina,
-- sólo si estos voluntarios pertenecen a instituciones que poseen director y si dicha cantidad es mayor que 5?

SELECT id_coordinador, count(*) FROM unc_esq_voluntario.voluntario v JOIN unc_esq_voluntario.institucion i
    ON v.id_institucion = i.id_institucion WHERE i.id_director IS NOT NULL
GROUP BY id_coordinador HAVING COUNT(*) > 5;
