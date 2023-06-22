--Ejemplo pedidos: Si un cliente hace un pedido de un articulo del que no hay suficiente stock,
-- debemos automaticamente hacer un pedido de fabricacion de ese articulo

--1. Creo las tablas
DROP TABLE IF EXISTS pedidos_clientes;
DROP TABLE IF EXISTS pedidos_a_fabrica;
DROP TABLE IF EXISTS stock;

CREATE TABLE pedidos_clientes (
codigo_articulo INTEGER,
cantidad INTEGER,
cliente INTEGER );

CREATE TABLE stock (
codigo_articulo INTEGER,
existencia INTEGER);
insert into stock values (100, 10),(101, 2),(102, 300);

CREATE TABLE pedidos_a_fabrica (
codigo_articulo INTEGER,
cantidad INTEGER );

--2. Creo la funccion
CREATE OR REPLACE FUNCTION FN_PEDIR_A_FABRICA()
RETURNS Trigger AS
    $$ --cuerpo de la funcion
    DECLARE v_existencia INTEGER;
BEGIN
    --Obtenemos la cantidad de existencia del articulo
    SELECT existencia
    INTO v_existencia
    FROM stock
    WHERE codigo_articulo=NEW.codigo_articulo;                                   --accedo al codigo
    IF(NEW.cantidad>v_existencia)                                                --si el pedido es mayor a la cantidad
        THEN                                                                     --entonces
        INSERT INTO pedidos_a_fabrica VALUES (NEW.codigo_articulo, NEW.cantidad); --pido a fabrica
    END IF;
    RETURN NEW;
END;
    $$
    LANGUAGE plpgsql;

--3. Creo el trigger
CREATE TRIGGER TR_PEDIR_A_FABRICA
    AFTER INSERT  ON pedidos_clientes  --evento insert
    FOR EACH ROW --se ejecuta por cada pedido
    EXECUTE PROCEDURE FN_PEDIR_A_FABRICA(); --accion

--4. Hago las pruebas de insertar
INSERT INTO pedidos_clientes VALUES ( 102, 50, 10);
INSERT INTO pedidos_clientes VALUES ( 101, 40, 20);
INSERT INTO pedidos_clientes VALUES ( 100, 30, 25);

SELECT * FROM pedidos_a_fabrica;


