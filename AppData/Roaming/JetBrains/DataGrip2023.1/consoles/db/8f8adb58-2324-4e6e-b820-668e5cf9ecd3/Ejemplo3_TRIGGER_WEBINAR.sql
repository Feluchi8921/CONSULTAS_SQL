--Ejemplo 3:
--Si al crear un pedido, este no cumple con ciertas validaciones, rechaza o modifica el pedido
--1) Cantidad debe ser mayor que cero
--2) Cliente debe existir en tabla clientes
--3) Si la cantidad es mayor que la existencia,se reduce la cantidad

DROP TABLE IF EXISTS pedidos_clientes;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS stock;

CREATE TABLE pedidos_clientes (
codigo_articulo INTEGER,
cantidad INTEGER,
cliente INTEGER );

CREATE TABLE clientes (
cliente_id INTEGER,
nombre TEXT);

INSERT INTO clientes values (10,'Juan Garcia'),(15,'Maria Gonzalez'),(20,'Pedro Lopez'),(25,'Catalina Perez');

CREATE TABLE stock (
codigo_articulo INTEGER,
existencia INTEGER);
insert into stock values (100, 10),(101, 2),(102, 300);


--1. Crear funcion
CREATE OR REPLACE FUNCTION FN_VALIDAR_PEDIDO()
RETURNS TRIGGER AS
$$
DECLARE existencia_cliente INTEGER;
DECLARE existencia_produco INTEGER;
DECLARE cant_stock INTEGER;
    BEGIN
    --verifico que exista el cliente
    SELECT COUNT(*) INTO existencia_cliente FROM clientes WHERE cliente_id=NEW.cliente;
    IF(existencia_cliente=0)
        THEN RAISE EXCEPTION 'El cliente % no existe', NEW.cliente;
    END IF;
    --verifico que el producto exista
    SELECT COUNT(*) INTO existencia_produco FROM stock WHERE codigo_articulo=NEW.codigo_articulo;
    IF(existencia_produco=0)
    THEN RAISE EXCEPTION 'EL producto % no exite', NEW.codigo_articulo;
    END IF;
    --verifico que la cantidad sea mayor a cero
    IF(NEW.cantidad<=0)
    THEN RAISE EXCEPTION 'La cantidad ingresada % no es mayor o igual a cero',NEW.cantidad;
    END IF;
    --verifico que la cantidad sea menor o igual al stock
    SELECT existencia
    INTO cant_stock
    FROM stock
    WHERE codigo_articulo=NEW.codigo_articulo;
    IF(cant_stock<NEW.cantidad)
    THEN                  --como no hay suficiente stock se reduce el pedido;
    NEW.cantidad=cant_stock;   --la cantidad se convierte en el valor guardado de existencia
    RETURN NEW;             --Este sera el registro a insertar, le cambiamos la cantidad
    END IF;
END $$
    LANGUAGE 'plpgsql';

--2. Crear trigger
--Tabla pedidos_clientes cantidad mayor que cero
CREATE TRIGGER TR_VALIDAR_PEDIDO
    BEFORE INSERT OR UPDATE OF cantidad
    ON pedidos_clientes
    FOR EACH ROW
    EXECUTE PROCEDURE FN_VALIDAR_PEDIDO();

--3. Hago las pruebas para ver cada item
INSERT INTO pedidos_clientes (codigo_articulo, cantidad, cliente) VALUES (100, 12, 8);
INSERT INTO pedidos_clientes (codigo_articulo, cantidad, cliente) VALUES (100, 0, 10);
INSERT INTO pedidos_clientes (codigo_articulo, cantidad, cliente) VALUES (100, 12, 10);
INSERT INTO pedidos_clientes (codigo_articulo, cantidad, cliente) VALUES (200, 12, 10);