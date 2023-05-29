-- RIR - RESTRICCIONES DE INTEGRIDAD REFERENCIAL ----
-- KAHOOT                                        ----
--
-- BORRADO DE TABLAS
DROP TABLE IF EXISTS CONTIENE;
DROP TABLE IF EXISTS ARTICULO;
DROP TABLE IF EXISTS PALABRA;

--CREACIÓN DE TABLAS
CREATE TABLE ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(50),
    CONSTRAINT PK_ARTICULO PRIMARY KEY (id_articulo)
);

CREATE TABLE PALABRA (
    idioma CHAR(3)  NOT NULL,
    cod_palabra int NOT NULL ,
    CONSTRAINT PK_PALABRA PRIMARY KEY (idioma, cod_palabra)
);

CREATE TABLE CONTIENE (
    id_articulo int  NOT NULL,
    idioma CHAR(3)  NOT NULL ,
    cod_palabra int NOT NULL ,
    CONSTRAINT PK_CONTIENE PRIMARY KEY (id_articulo, idioma, cod_palabra)
);

ALTER TABLE CONTIENE ADD CONSTRAINT FK_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES ARTICULO (id_articulo)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
;
--Alter table CONTIENE drop constraint FK_CONTIENE_ARTICULO;

ALTER TABLE CONTIENE ADD CONSTRAINT FK_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES PALABRA (idioma, cod_palabra)
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

-- CARGA DE DATOS
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (1, 'A');
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (2, 'B');
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (3, 'C');
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (4, 'D');

INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ESP', 1);
INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ENG', 3);
INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ESP', 2);
INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ENG', 1);

INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ESP', 1);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ESP', 2);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ENG', 3);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (2, 'ESP', 1);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (2, 'ESP', 2);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (3, 'ENG', 3);

-------------------Consultas------------
--1. ERROR: actualizar o eliminar en la tabla "articulo" viola la restricción de clave externa "fk_contiene_articulo" en la tabla "contiene"
--Detalle: La clave (id_articulo)=(1) aún se referencia desde la tabla "contiene".
DELETE FROM ARTICULO WHERE id_articulo=1;

--2. Se puede eliminar porque en la tabla Contiene no hay ningun resgistro con id_articulo=4.
DELETE FROM ARTICULO WHERE id_articulo=4;

--3. Elimina la fila 1 de la tabla palabra, y las filas 1 y 4 de la tabla contiene, porque la restriccion es cascade, pero no
--elimina las filas con id_articulo=1 de la tabla articulo, porque es restrict
DELETE FROM PALABRA WHERE idioma='ESP' AND cod_palabra=1;

--4. Elimina solo las con cod_palabra=1 e idioma español de la tabla contiene porque la tabla palabra no tiene fk, y la tabla articulo tiene fk delete restrict.
DELETE FROM CONTIENE WHERE idioma='ESP' AND cod_palabra=1;

--5. Elimina la fila con cod_palabra=1 e idioma ingles, de la tabla Palabra. Porque en la tabla contiene no hay registro de cod_palabra=1
DELETE FROM PALABRA WHERE idioma='ENG' AND cod_palabra=1;

--6. No se puede porque la restriccion de fk de la tabla articulo es update restrict.
--ERROR: actualizar o eliminar en la tabla "articulo" viola la restricción de clave externa "fk_contiene_articulo" en la tabla "contiene"
--Detalle: La clave (id_articulo)=(1) aún se referencia desde la tabla "contiene".
UPDATE ARTICULO SET id_articulo=5 WHERE id_articulo=1;

--7. Se puede actualizar el valor porque no existe ningun registro con d_articulo=4 en la tabla contiene.
UPDATE ARTICULO SET id_articulo=7 WHERE id_articulo=4;

--8. Se puede actualizar, las tablas palabra y contiene porque son cascade. Se actualiza el registro con cod=1 de la tabla
--palabra y los dos regsitros con cod=1 de la tabla contiene.
UPDATE PALABRA SET idioma='POR' WHERE idioma='ESP' AND cod_palabra=1;

--9. Se puede, actualiza la fila con cod_palabra=1 e idioma ingles, de la tabla palabra.
UPDATE PALABRA SET idioma='POR' WHERE idioma='ENG' AND cod_palabra=1;

--10. Actualiza solamente el registro con id=3 a 4 de la tabla contiene porque las otras tablas no tienen fk
UPDATE CONTIENE SET id_articulo=4 WHERE id_articulo=3 AND idioma='ENG' AND cod_palabra=3;

--11. No se puede porque id=8 no existe en la tabla ARTICULO entonces quedaria nulo y viola la no nulidad de la pk.
UPDATE CONTIENE SET id_articulo=8 WHERE id_articulo=3 AND idioma='ENG' AND cod_palabra=3;


