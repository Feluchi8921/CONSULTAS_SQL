SELECT count(id_empleado) FROM unc_esq_peliculas.empleado
        WHERE (sueldo IS NULL
                        AND porc_comision IS NOT NULL);

SELECT id_pais, COUNT(distinct id_pais) FROM unc_esq_peliculas.ciudad WHERE UPPER(nombre_ciudad) LIKE '%IA'
GROUP BY id_pais;

--Listar cant_ciudades que terminen con IA por pais (esta es la manera correcta)
SELECT id_pais, COUNT(distinct id_ciudad) FROM unc_esq_peliculas.ciudad WHERE UPPER(nombre_ciudad) LIKE '%IA'
GROUP BY id_pais;

SELECT t.id_tarea, t.nombre_tarea FROM unc_esq_peliculas.tarea t INNER JOIN unc_esq_peliculas.empleado e ON
t.id_tarea=e.id_tarea WHERE (id_empleado IS NULL AND sueldo_maximo>14500)
                                    ORDER BY  t.sueldo_minimo DESC LIMIT 3;
SELECT id_tarea, nombre_tarea, sueldo_minimo FROM unc_esq_peliculas.tarea t WHERE sueldo_maximo>14500 AND id_tarea NOT IN(
    SELECT id_tarea FROM unc_esq_peliculas.empleado e) ORDER BY sueldo_minimo DESC LIMIT 3;


SELECT COUNT(distinct e.id_empleado) FROM unc_esq_peliculas.empleado e INNER JOIN unc_esq_peliculas.departamento d
ON (e.id_departamento=d.id_departamento AND e.id_distribuidor=d.id_distribuidor) INNER JOIN unc_esq_peliculas.distribuidor dis
ON d.id_distribuidor = dis.id_distribuidor INNER JOIN unc_esq_peliculas.entrega ent ON dis.id_distribuidor = ent.id_distribuidor
WHERE (EXTRACT(YEAR FROM fecha_entrega)=2006
AND EXTRACT(YEAR FROM fecha_entrega)=2009) GROUP BY e.id_distribuidor HAVING COUNT(nro_entrega)>3;



CREATE ASSERTION ck_x_atencion_x_especialidad_max_10_medicos(NOT EXISTS(SELECT 1 FROM CENTRO_SALUD cs INNER JOIN ATIENDE a
    ON (cs.cod_centro=a.cod_centro) GROUP BY sala_atencion, tipo_especialidad HAVING COUNT(nro_matricula)>10));

    SELECT 1 FROM CENTRO_SALUD cs INNER JOIN ATIENDE a
    ON (cs.cod_centro=a.cod_centro) GROUP BY sala_atencion, tipo_especialidad HAVING COUNT(nro_matricula)>10;


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-28 00:43:08.428

-- tables
-- Table: ATIENDE
CREATE TABLE ATIENDE (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    cod_centro int  NOT NULL,
    CONSTRAINT PK_ATIENDE PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad,cod_centro)
);

-- Table: CENTRO_SALUD
CREATE TABLE CENTRO_SALUD (
    cod_centro int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sala_atencion boolean  NOT NULL,
    CONSTRAINT PK_CENTRO_SALUD PRIMARY KEY (cod_centro)
);

-- Table: ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: MEDICO
CREATE TABLE MEDICO (
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
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_CENTRO_SALUD
    FOREIGN KEY (cod_centro)
    REFERENCES CENTRO_SALUD (cod_centro)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ATIENDE_MEDICO (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_MEDICO
    FOREIGN KEY (nro_matricula, tipo_especialidad, cod_especialidad)
    REFERENCES MEDICO (nro_matricula, tipo_especialidad, cod_especialidad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_MEDICO_ESPECIALIDAD (table: MEDICO)
ALTER TABLE MEDICO ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
    REFERENCES ESPECIALIDAD (tipo_especialidad, cod_especialidad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

