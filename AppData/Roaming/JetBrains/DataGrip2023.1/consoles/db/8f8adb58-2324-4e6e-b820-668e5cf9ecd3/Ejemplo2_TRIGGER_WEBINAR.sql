--Ejemplo 2
--Si al crear un pedido no cumple con ciertas validaciones, entonces se rechaza la creacion del pedido
--1)cantidad deber ser mayor que cero
--2)cliente debe existir en la tabla clientes

DROP TABLE IF EXISTS pedidos_clientes;
DROP TABLE IF EXISTS clientes;

CREATE TABLE pedidos_clientes (
codigo_articulo INTEGER,
cantidad INTEGER,
cliente INTEGER );

CREATE TABLE clientes (
cliente_id INTEGER,
nombre TEXT);

INSERT INTO clientes values (10,'Juan Garcia'),(15,'Maria Gonzalez'),(20,'Pedro Lopez'),(25,'Catalina Perez');

--Trigger before permite rechazar el evento y retornar null

--1.Creo la funcion
CREATE OR REPLACE FUNCTION FN_VALIDAR_PEDIDO()
RETURNS trigger AS
    $$
    DECLARE v_existencia_cliente INTEGER;
BEGIN
    --verificamos si existe el cliente
        SELECT count(*)
        INTO v_existencia_cliente
        FROM clientes
        WHERE cliente_id=NEW.cliente;                                           --lo comparo con el nuevo cliente
    IF(v_existencia_cliente=0)                                                  --si el cliente no existe
        THEN RAISE EXCEPTION 'El cliente: % no existe', NEW.cliente;                            --msj error
    END IF;
    IF(NEW.cantidad <=0)                                                         --si la cantidad es negativa
        THEN RAISE EXCEPTION 'La cantidad ingresada es: %. No puede ser menor o igual a cero', NEW.cantidad;    --msj error
    END IF;                       --si pasó por los pasos anteriores y dio falso, entonces procede a la insercion del registro
    RETURN NEW;                                      --esto significa que se insertara el registro en la vatiable record NEW
    END;
    $$
LANGUAGE 'plpgsql';

--2. Creo el trigger
CREATE TRIGGER TR_VALIDAR_PEDIDO
    BEFORE INSERT ON pedidos_clientes
    FOR EACH ROW
    EXECUTE PROCEDURE FN_VALIDAR_PEDIDO();

--3. Hago la prueba
INSERT INTO pedidos_clientes VALUES (100, 20, 15);
INSERT INTO pedidos_clientes VALUES (101, 0, 15);
INSERT INTO pedidos_clientes VALUES (101,1, 30)