--1. No puede haber voluntarios de más de 70 años.

ALTER TABLE esq_voluntarios_voluntario ADD CONSTRAINT ck_voluntario_edad CHECK (age(fecha_nacimiento)<='70 YEAR');
--Pruebo si salta el error:
INSERT INTO esq_voluntarios_voluntario
    (nombre, apellido, e_mail, telefono, fecha_nacimiento, id_tarea, nro_voluntario, horas_aportadas, porcentaje, id_institucion, id_coordinador)
values ('Felicitas', 'Aguerralde', 'feluchi_89@gmail.com', +416431656647, '1952-03-22', 'ST_CLERK' , 1200, 2900.00, 0.40, 80, 50);
--Borrado de ck :
ALTER TABLE esq_voluntarios_voluntario DROP CONSTRAINT ck_voluntario_edad;

--2.