CREATE FUNCTION Ejemplo2(integer, integer)
DECLARE
    RETURNS integer AS $$ //va esto?
    numero1 ALIAS FOR $1;
    numero2 ALIAS FOR $2;
    constante CONSTANT integer:=100;
    resultado INTEGER;
    resultado_txt TEXT DEFAULT 'Texto por defecto';
    tipo_reg voluntario%rowtype;
    tipo_col voluntario.nombre%type;
    $$ LANGUAGE 'plpdsql';

CREATE OR REPLACE FUNCTION Sumador (integer)
RETURNS integer AS $$
    BEGIN
    RETURN $1 + 1;
    END; $$ LANGUAGE 'plpdsql';


CREATE OR REPLACE FUNCTION Sumador (unNumero integer)
RETURNS integer AS $$
    BEGIN
    RETURN unNumero + 1;
    END; $$ LANGUAGE  'plpgsql';

-- Tipos de retorno de funciones (ESTA SEPARADO EL DISPARADOR DEL CODIGO, codigo que se ejecuta cuando se hace un insert,
-- delete o update)
--void no retorna nada (no deberìa usarse par una funcion porque siempre retorna algo
--trigger, debe ser seteada para los tipos de trigger
--boolean, text, ect, retorna valores
--SET OF schema.table retorna varias filas de datos

CREATE TABLE tabla1 (
    clave SERIAL,
    valor INTEGER,
    valor_tipo VARCHAR,
    PRIMARY KEY (clave)
);
CREATE TABLE tabla2 (
    clave INTEGER,
    valor INTEGER,
    valor_tipo VARCHAR,
    user_name NAME,
    accion VARCHAR,
    accion_hora TIMESTAMP,
    PRIMARY KEY (clave)
);
--TRIGGER codigo que se ejecuta de forma implicita
CREATE FUNCTION copia_tabla_1()
RETURNS trigger AS $body$
BEGIN
    IF(TG_OP='INSERT')OR(TG_OP='UPDATE') THEN
        INSERT INTO tabla2
        VALUES (NEW.clase, NEW.valor, NEW.valor_tipo, current_user, TG_OP, now());
RETURN NEW;
END IF;
IF TG_OP='DELETE' THEN
    INSERT INTO tabla2
    VALUES (OLD.clave, OLD.valor, OLD.tipo_valor, current_user, TG_OP, now());
RETURN OLD;
END IF;
END; $body$
LANGUAGE 'plpgsql';

CREATE TRIGGER tabla1_tr
    BEFORE INSERT OR UPDATE OR DELETE
    ON tabla1 FOR EACH ROW
    EXECUTE PROCEDURE copia_tabla1();

INSERT INTO tabla1 (valor, valor_tipo) VALUES ('30','metros');
INSERT INTO tabla1 (valor, valor_tipo) VALUES ('10', 'pulgadas');
UPDATE tabla1 SET valor='20' WHERE valor_tipo='pulgadas';
DELETE FROM tabla1 WHERE valor_tipo='pulgadas';
INSERT INTO tabla1 (valor, valor_tipo) VALUES ('50', 'pulgadas');
--BEFORE-AFTER------------------------------------------------------
--BEFORE ejecuta antes AFTER despues
--insert-before: new: dato nuevo, old: null, tabla: no esta
--insert-after: new: dato nuevo, old: null, tabla:dato nuevo
--update-before: new: nuevo dato, old: dato viejo, tabla: dato viejo
--update-before: new: nuevo dato, old: dato viejo, tabla: dato nuevo
--delete-before: new: null, old: viejo, tabla: viejo
--delte-after: new: null, old: viejo, tabla: null

CREATE TRIGGER  tr_controlarticulo
    after insert or update of id_articulo
    on contiene execute function fn_control();
--EJEMPLO
CREATE TABLE contiene(
    id_art int not null,
    id_palabra int not null,
    constraint pk_contiene primary key (id_art, id_palabra));

select*from contiene;

CREATE FUNCTION fn_control() returns trigger as $$
    BEGIN
    IF(exists(select 1 from contiene group by id_art having count(*)>3))
    then raise exception 'No se puede';
    end if;
    return new;
    END; $$ LANGUAGE 'plpgsql'
    ;

CREATE TRIGGER tr_control
    after insert on contiene
    execute function fn_control();

insert into contiene(id_art, id_palabra) values (1,1);