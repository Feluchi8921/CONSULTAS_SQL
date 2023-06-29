--Resolucion Segundo Parcial Base de Datos TEMA 2 - 2023
--Ejercicio:2

-- cambiar el 251952 por su número de libreta
set search_path = unc_246646;
DROP TABLE IF EXISTS unc_246646_ATIENDE CASCADE;
DROP TABLE IF EXISTS unc_246646_CENTRO_SALUD CASCADE;
DROP TABLE IF EXISTS unc_246646_ESPECIALIDAD CASCADE ;
DROP TABLE IF EXISTS unc_246646_MEDICO CASCADE;

-- Table: ATIENDE
CREATE TABLE unc_246646_ATIENDE (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    cod_centro int  NOT NULL,
    CONSTRAINT PK_ATIENDE PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad,cod_centro)
);

-- Table: CENTRO_SALUD
CREATE TABLE unc_246646_CENTRO_SALUD (
    cod_centro int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sala_atencion boolean  NOT NULL,
    CONSTRAINT PK_CENTRO_SALUD PRIMARY KEY (cod_centro)
);

-- Table: ESPECIALIDAD
CREATE TABLE unc_246646_ESPECIALIDAD (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: MEDICO
CREATE TABLE unc_246646_MEDICO (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    email varchar(30)  NOT NULL,
    CONSTRAINT PK_MEDICO PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad)
);

-- foreign keys
-- Reference: FK_ATIENDE_CENTRO_SALUD (table: ATIENDE)
ALTER TABLE unc_246646_ATIENDE ADD CONSTRAINT FK_ATIENDE_CENTRO_SALUD
    FOREIGN KEY (cod_centro)
    REFERENCES unc_246646_CENTRO_SALUD (cod_centro);

-- Reference: FK_ATIENDE_MEDICO (table: ATIENDE)
ALTER TABLE unc_246646_ATIENDE ADD CONSTRAINT FK_ATIENDE_MEDICO
    FOREIGN KEY (nro_matricula, tipo_especialidad, cod_especialidad)
    REFERENCES unc_246646_MEDICO (nro_matricula, tipo_especialidad, cod_especialidad);

-- Reference: FK_MEDICO_ESPECIALIDAD (table: MEDICO)
ALTER TABLE unc_246646_MEDICO ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
    REFERENCES unc_246646_ESPECIALIDAD (tipo_especialidad, cod_especialidad);


-- Datos

INSERT INTO unc_246646_ESPECIALIDAD (tipo_especialidad,cod_especialidad,descripcion)
VALUES
  ('K0W',49,'est'),  ('M5G',92,'massa lobortis'),  ('K1J',43,'elementum at,'),  ('K5G',84,'nibh. Aliquam'),  ('B5D',60,'lacinia mattis. Integer'),
  ('Y5P',48,'luctus'),  ('P2U',76,'tellus eu'),  ('Y6X',52,'elit. Curabitur sed'),  ('O4G',11,'imperdiet non,'),  ('V9B',96,'sem semper erat,');

INSERT INTO unc_246646_CENTRO_SALUD (cod_centro,nombre,calle,numero,sala_atencion)
VALUES
  (1,'Mira Battle','Larissa Shaffer',9170,'Yes'),  (2,'Otto Mcclain','Colin Duffy',2795,'No'),  (3,'Ishmael Poole','Tashya Waters',9688,'No'),  (4,'Dale Cochran','Lavinia Austin',8776,'Yes'),
  (5,'Holly Douglas','Noelani Conner',3209,'Yes'),  (6,'Kylee Horn','Erica Vaughan',1799,'No'),  (7,'Abra Hickman','Cailin French',6326,'Yes'),  (8,'Eaton Brady','Summer Nielsen',8230,'Yes'),
  (9,'Judah Maldonado','Gabriel Hall',1296,'Yes'),  (10,'Rebekah Benton','Laith Young',5358,'Yes'),  (11,'Armand Vance','Nero Abbott',303,'Yes'),  (12,'Amaya Jefferson','Kerry Fowler',5828,'Yes'),
  (13,'Mohammad Ramsey','Driscoll Burgess',6675,'Yes'),  (14,'Clarke Ferguson','Joseph Chang',8255,'Yes'),  (15,'Herrod Ortega','Brody Higgins',2951,'No');

INSERT INTO unc_246646_MEDICO (tipo_especialidad, cod_especialidad, nro_matricula, nombre, apellido, email)
VALUES
('Y6X', 52, 1, 'Nombre 1', 'Apellido 1', 'email@gmail.com'), ('P2U', 76, 2, 'Nombre 2', 'Apellido 2', 'email@gmail.com'), ('B5D', 60, 3, 'Nombre 3', 'Apellido 3', 'email@gmail.com'), ('K5G', 84, 4, 'Nombre 4', 'Apellido 4', 'email@gmail.com'),
 ('Y6X', 52, 5, 'Nombre 5', 'Apellido 5', 'email@gmail.com'), ('O4G', 11, 6, 'Nombre 6', 'Apellido 6', 'email@gmail.com'), ('V9B', 96, 7, 'Nombre 7', 'Apellido 7', 'email@gmail.com'), ('K0W', 49, 8, 'Nombre 8', 'Apellido 8', 'email@gmail.com'),
 ('K5G', 84, 9, 'Nombre 9', 'Apellido 9', 'email@gmail.com'), ('Y6X', 52, 10, 'Nombre 10', 'Apellido 10', 'email@gmail.com'), ('K5G', 84, 11, 'Nombre 11', 'Apellido 11', 'email@gmail.com'), ('K0W', 49, 12, 'Nombre 12', 'Apellido 12', 'email@gmail.com'),
 ('V9B', 96, 13, 'Nombre 13', 'Apellido 13', 'email@gmail.com'), ('M5G', 92, 14, 'Nombre 14', 'Apellido 14', 'email@gmail.com'), ('Y5P', 48, 15, 'Nombre 15', 'Apellido 15', 'email@gmail.com'), ('K1J', 43, 16, 'Nombre 16', 'Apellido 16', 'email@gmail.com'), ('K5G', 84, 17, 'Nombre 17', 'Apellido 17', 'email@gmail.com'), ('B5D', 60, 18, 'Nombre 18', 'Apellido 18', 'email@gmail.com'), ('K5G', 84, 19, 'Nombre 19', 'Apellido 19', 'email@gmail.com'),
 ('O4G', 11, 20, 'Nombre 20', 'Apellido 20', 'email@gmail.com'), ('Y5P', 48, 21, 'Nombre 21', 'Apellido 21', 'email@gmail.com'), ('B5D', 60, 22, 'Nombre 22', 'Apellido 22', 'email@gmail.com'), ('O4G', 11, 23, 'Nombre 23', 'Apellido 23', 'email@gmail.com'),
 ('Y5P', 48, 24, 'Nombre 24', 'Apellido 24', 'email@gmail.com'), ('M5G', 92, 25, 'Nombre 25', 'Apellido 25', 'email@gmail.com'), ('Y5P', 48, 26, 'Nombre 26', 'Apellido 26', 'email@gmail.com'), ('Y5P', 48, 27, 'Nombre 27', 'Apellido 27', 'email@gmail.com'),
 ('V9B', 96, 28, 'Nombre 28', 'Apellido 28', 'email@gmail.com'), ('V9B', 96, 29, 'Nombre 29', 'Apellido 29', 'email@gmail.com'), ('V9B', 96, 30, 'Nombre 30', 'Apellido 30', 'email@gmail.com');

INSERT INTO unc_246646_ATIENDE (tipo_especialidad, cod_especialidad, nro_matricula, cod_centro) VALUES
('M5G', 92, 14, 10),('K1J', 43, 16, 4),('Y5P', 48, 15, 1),('B5D', 60, 3, 3),('K5G', 84, 4, 4),('K0W', 49, 12, 6),('V9B', 96, 28, 3),('V9B', 96, 29, 6),('V9B', 96, 7, 10),('Y6X', 52, 10, 5),('O4G', 11, 6, 2),('Y5P', 48, 24, 8),
('O4G', 11, 20, 8),('Y6X', 52, 10, 9),('K5G', 84, 4, 8),('V9B', 96, 29, 1),('M5G', 92, 25, 8),('K0W', 49, 8, 3),('V9B', 96, 29, 9),('B5D', 60, 18, 2),('B5D', 60, 22, 9),('K5G', 84, 19, 10),('Y6X', 52, 1, 2),('O4G', 11, 23, 2),
('B5D', 60, 22, 5),('K5G', 84, 4, 1),('Y5P', 48, 27, 9),('V9B', 96, 13, 1),('B5D', 60, 22, 10),('M5G', 92, 25, 6),('Y5P', 48, 15, 9),('V9B', 96, 29, 4),('K0W', 49, 12, 5),('K1J', 43, 16, 9),('K5G', 84, 19, 7),('Y5P', 48, 26, 8),
('V9B', 96, 7, 4),('Y5P', 48, 27, 7),('K5G', 84, 19, 3),('V9B', 96, 28, 10),('O4G', 11, 23, 7),('O4G', 11, 6, 6),('V9B', 96, 30, 1),('Y5P', 48, 21, 10),('Y5P', 48, 15, 6),('V9B', 96, 7, 2),('O4G', 11, 23, 3),('O4G', 11, 20, 3),
('Y5P', 48, 26, 6),('Y5P', 48, 15, 5),('V9B', 96, 30, 7),('Y5P', 48, 21, 2),('K5G', 84, 4, 2),('K5G', 84, 11, 4),('V9B', 96, 7, 6),('O4G', 11, 23, 4),('Y6X', 52, 10, 7),('V9B', 96, 28, 6),('B5D', 60, 3, 2),('B5D', 60, 18, 1),
('K5G', 84, 9, 8),('Y5P', 48, 26, 1),('O4G', 11, 23, 1),('M5G', 92, 14, 6),('O4G', 11, 6, 1),('Y6X', 52, 5, 7),('V9B', 96, 7, 5),('P2U', 76, 2, 3),('B5D', 60, 3, 4),('B5D', 60, 22, 2),('Y6X', 52, 1, 7),('V9B', 96, 29, 5),
('K0W', 49, 8, 6),('O4G', 11, 20, 2),('K5G', 84, 19, 9),('Y5P', 48, 26, 2),('P2U', 76, 2, 8),('V9B', 96, 30, 2),('K5G', 84, 4, 7),('M5G', 92, 14, 8),('Y5P', 48, 24, 2),('B5D', 60, 3, 9),('V9B', 96, 7, 1),('B5D', 60, 3, 1),
('Y6X', 52, 1, 3),('K5G', 84, 11, 6),('P2U', 76, 2, 9),('Y6X', 52, 10, 10),('B5D', 60, 3, 5),('Y6X', 52, 1, 5),('Y6X', 52, 10, 1),('V9B', 96, 13, 6),('K5G', 84, 9, 4),('V9B', 96, 13, 8),('O4G', 11, 20, 7),('B5D', 60, 18, 5),
('V9B', 96, 30, 3),('Y5P', 48, 15, 4),('B5D', 60, 22, 7),('Y5P', 48, 21, 8),('K5G', 84, 11, 9),('K5G', 84, 9, 2),('P2U', 76, 2, 2),('V9B', 96, 13, 4),('O4G', 11, 6, 5),('K0W', 49, 12, 7),('Y6X', 52, 5, 9),('Y6X', 52, 5, 1),
('M5G', 92, 25, 2),('M5G', 92, 14, 9),('O4G', 11, 6, 4),('V9B', 96, 30, 6),('Y5P', 48, 27, 5),('O4G', 11, 6, 10),('Y6X', 52, 1, 10),('Y5P', 48, 26, 3),('Y6X', 52, 5, 2),('P2U', 76, 2, 10),('Y5P', 48, 15, 10),('K5G', 84, 11, 10),
('Y6X', 52, 5, 6),('Y5P', 48, 24, 6),('P2U', 76, 2, 7),('K5G', 84, 17, 2),('V9B', 96, 13, 7),('Y5P', 48, 26, 9),('Y5P', 48, 15, 8),('K0W', 49, 12, 8),('Y5P', 48, 15, 7),('B5D', 60, 18, 4),('O4G', 11, 20, 4),('K5G', 84, 4, 5),
('O4G', 11, 6, 3),('V9B', 96, 29, 8),('O4G', 11, 6, 7),('Y6X', 52, 1, 8),('K5G', 84, 17, 8),('O4G', 11, 23, 10),('Y6X', 52, 1, 4),('K1J', 43, 16, 8),('V9B', 96, 29, 10),('K1J', 43, 16, 7);

--Creado de columnas
ALTER TABLE unc_246646_ESPECIALIDAD ADD cant_med int default 0;
ALTER TABLE unc_246646_ESPECIALIDAD ADD cant_atenciones int default 0;

--Inicialización
UPDATE unc_246646_especialidad e SET
    cant_med = coalesce((SELECT COUNT(*) FROM unc_246646_MEDICO m
                        WHERE m.cod_especialidad = e.cod_especialidad
                        AND m.tipo_especialidad=e.tipo_especialidad), 0),
    cant_atenciones =coalesce((SELECT COUNT(*)
                FROM unc_246646_MEDICO m
                JOIN unc_246646_ATIENDE a ON (m.nro_matricula= a.nro_matricula AND m.tipo_especialidad=a.tipo_especialidad)
        WHERE m.cod_especialidad=e.cod_especialidad
        AND m.tipo_especialidad=e.tipo_especialidad),0);

--Funciones
CREATE FUNCTION FN_ATIENDE() RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP='INSERT' OR TG_OP='UPDATE') THEN
        UPDATE unc_246646_ESPECIALIDAD e SET
        cant_atenciones = coalesce((SELECT COUNT(*)
                        FROM unc_246646_MEDICO m
                            JOIN unc_246646_ATIENDE a ON (m.nro_matricula=a.nro_matricula AND m.cod_especialidad = a.cod_especialidad)
                        WHERE m.cod_especialidad=e.cod_especialidad AND m.tipo_especialidad=e.tipo_especialidad),0)
                        WHERE tipo_especialidad=new.tipo_especialidad AND cod_especialidad=new.cod_especialidad;
    END IF;
    IF(TG_OP='DELETE' OR TG_OP='UPDATE') THEN
    UPDATE unc_246646_ESPECIALIDAD e SET
        cant_atenciones = coalesce((SELECT COUNT(*)
                        FROM unc_246646_MEDICO m
                            JOIN unc_246646_ATIENDE a ON (m.nro_matricula=a.nro_matricula AND m.cod_especialidad = a.cod_especialidad)
                        WHERE m.cod_especialidad=e.cod_especialidad AND m.tipo_especialidad=e.tipo_especialidad),0)
                        WHERE tipo_especialidad=old.tipo_especialidad AND cod_especialidad=old.cod_especialidad;
        IF(TG_OP='DELETE') THEN
        RETURN OLD;
        END IF;
    END IF;
RETURN NEW;
END;
$$LANGUAGE 'plpgsql';
--Creo el trigger
CREATE TRIGGER TR_ATIENDE
    AFTER INSERT OR DELETE OR UPDATE OF cod_especialidad, tipo_especialidad
    ON unc_246646_ATIENDE
    FOR EACH ROW
    EXECUTE FUNCTION FN_ATIENDE();

--Creo la funcion medico
CREATE FUNCTION FN_MEDICO()
    RETURNS TRIGGER AS $$
    BEGIN
        IF(TG_OP='INSERT' OR TG_OP='UPDATE') THEN
            UPDATE unc_246646_ESPECIALIDAD e SET
                    cant_med = coalesce((SELECT COUNT(*)
                                         FROM unc_246646_MEDICO m
                                         WHERE m.cod_especialidad=e.cod_especialidad AND m.tipo_especialidad=e.tipo_especialidad),0)
                                         WHERE tipo_especialidad=new.tipo_especialidad AND cod_especialidad=new.cod_especialidad;
        END IF;
        IF(TG_OP='DELETE' OR TG_OP='UPDATE') THEN
            UPDATE unc_246646_ESPECIALIDAD e SET
                cant_med = coalesce((SELECT COUNT(*)
                                      FROM unc_246646_MEDICO m
                                         WHERE m.cod_especialidad=e.cod_especialidad AND m.tipo_especialidad=e.tipo_especialidad),0)
                                         WHERE tipo_especialidad=old.tipo_especialidad AND cod_especialidad=old.cod_especialidad;
            IF(TG_OP = 'DELETE') THEN
                RETURN OLD;
            END IF;
        END IF;
RETURN NEW;
END;
$$LANGUAGE 'plpgsql';

--Creo el trigger
CREATE TRIGGER TR_MEDICO
    AFTER INSERT OR DELETE OR UPDATE OF cod_especialidad, tipo_especialidad
    ON unc_246646_MEDICO
    FOR EACH ROW
    EXECUTE FUNCTION FN_MEDICO();

--Hago la prueba
SELECT * FROM unc_246646_ESPECIALIDAD;