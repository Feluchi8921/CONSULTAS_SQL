--1. No puede haber voluntarios de más de 70 años.

ALTER TABLE esq_voluntarios_voluntario ADD CONSTRAINT ck_voluntario_edad CHECK (age(fecha_nacimiento)<='70 YEAR');
--Pruebo si salta el error:
INSERT INTO esq_voluntarios_voluntario
    (nombre, apellido, e_mail, telefono, fecha_nacimiento, id_tarea, nro_voluntario, horas_aportadas, porcentaje, id_institucion, id_coordinador)
values ('Felicitas', 'Aguerralde', 'feluchi_89@gmail.com', +416431656647, '1952-03-22', 'ST_CLERK' , 1200, 2900.00, 0.40, 80, 50);
--Borrado de ck :
ALTER TABLE esq_voluntarios_voluntario DROP CONSTRAINT ck_voluntario_edad;

--2.Ningún voluntario puede aportar más horas que las de su coordinador.
ALTER TABLE esq_voluntarios_voluntario ADD CONSTRAINT ck_horas CHECK (NOT EXISTS(SELECT 1
FROM esq_voluntarios_voluntario v INNER JOIN esq_voluntarios_voluntario c ON v.id_coordinador = c.nro_voluntario
WHERE v.horas_aportadas>c.horas_aportadas));

--3. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y mínimos consignados en la tarea.
CREATE ASSERTION ck_horas_aportadas_entre_max_min CHECK
(NOT EXISTS (SELECT * FROM esq_voluntarios_voluntario v INNER JOIN esq_voluntarios_tarea t ON v.id_tarea=t.id_tarea
WHERE (horas_aportadas>max_horas OR horas_aportadas<min_horas));

--4. Todos los voluntarios deben realizar la misma tarea que su coordinador.
ALTER TABLE esq_voluntarios_voluntario ADD CONSTRAINT (NOT EXISTS(SELECT 1 FROM esq_voluntarios_voluntario v INNER JOIN esq_voluntarios_voluntario c ON v.nro_voluntario=c.id_coordinador
   WHERE v.id_tarea!=c.id_tarea));

--5. Los voluntarios no pueden cambiar de institución más de tres veces en el año.
ALTER TABLE esq_voluntarios_historico ck_cambio_insitucion_menor_o_igual_3 CHECK (NOT EXISTS
    (SELECT (EXTRACT(YEAR FROM h.fecha_inicio)), nro_voluntario FROM esq_voluntarios_historico h
     GROUP BY (EXTRACT(YEAR FROM h.fecha_inicio)), nro_voluntario HAVING COUNT(*)>3));

--6. En el histórico, la fecha de inicio debe ser siempre menor que la fecha de finalización.
ALTER TABLE esq_voluntarios_historico ck_fecha_inicio_menor_fecha_fin CHECK(NOT EXISTS
    (SELECT fecha_inicio, fecha_fin FROM esq_voluntarios_historico WHERE fecha_inicio>fecha_fin));

