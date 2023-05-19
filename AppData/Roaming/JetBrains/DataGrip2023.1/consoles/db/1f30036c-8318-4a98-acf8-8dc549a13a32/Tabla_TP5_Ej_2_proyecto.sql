--b.1)
delete from tp5_p1_ej2_proyecto where id_proyecto = 3;
--lo vuelvo a insertar
INSERT INTO tp5_p1_ej2_proyecto VALUES (3, 'Proy 3', 2020, NULL);

--b.2)
update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;
delete from tp5_p1_ej2_proyecto where id_proyecto=7;
--lo vuelvo como estaba
INSERT INTO tp5_p1_ej2_proyecto VALUES (3, 'Proy 3', 2020, NULL);

--b.3)
delete from tp5_p1_ej2_proyecto where id_proyecto = 1;
--No se puede--

--b.4)
delete from tp5_p1_ej2_empleado where tipo_empleado = 'A' and nro_empleado = 2;
select * from tp5_p1_ej2_empleado where tipo_empleado = 'A' and nro_empleado = 2;
-- lo vuelvo atras--
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 2, 'María', 'Casio', 'CIO');
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 2, 2, 25, 'T3');

--b.5)
update tp5_p1_ej2_trabaja_en set id_proyecto  = 3 where id_proyecto  =1;
--lo vuelvo atras--
update tp5_p1_ej2_trabaja_en set id_proyecto  = 1 where id_proyecto  =3;

--b.6)
update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;

--B)
--Primero agrego  el dato
insert into tp5_p1_ej2_empleado (tipo_empleado, nro_empleado, nombre, apellido, cargo) VALUES ('B', 10, 'Feli', 'Ague', 'jefe');
insert into tp5_p1_ej2_proyecto (id_proyecto, nombre_proyecto, anio_inicio, anio_fin) values (66, 'NN', 2022, 2023);
insert into tp5_p1_ej2_auspicio  (id_proyecto, nombre_auspiciante, tipo_empleado, nro_empleado) VALUES (66, 'Mc Donald', 'B', 10);
--ahora hago la consulta
update tp5_p1_ej2_auspicio set id_proyecto= 66, nro_empleado = 10
  where id_proyecto = 22
      and tipo_empleado = 'A'
      and nro_empleado = 5;
--luego reviso lo que modifique
select * from tp5_p1_ej2_auspicio where id_proyecto=66;
