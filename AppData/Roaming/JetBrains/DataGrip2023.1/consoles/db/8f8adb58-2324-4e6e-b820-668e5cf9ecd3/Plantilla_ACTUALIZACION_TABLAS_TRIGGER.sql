CREATE OR REPLACE FUNCTION FN_FUNCION()
    RETURNS TRIGGER AS $$
    BEGIN
        --Actualizacion por insert:
        IF TG_OP='INSERT' THEN             --si inserto en tarea, inserto un registro en his_tarea con la operacion insert
            INSERT INTO his_tarea (fecha, operacion, usuario) VALUES (CURRENT_DATE, TG_OP, CURRENT_USER);
        RETURN NEW;
        END IF;
        --Actualizacion por update:
        IF TG_OP='UPDATE' THEN          --si modifico la tabla tarea, inserto un registro en his_tarea con la operacion update
            INSERT INTO his_tarea (fecha, operacion, usuario) VALUES (CURRENT_DATE, TG_OP, CURRENT_USER);       --inserto el nuevo valor
        RETURN NEW;
        END IF;
        --Actualizacion por delete:
        IF TG_OP='DELETE' THEN          --si elimino un resgitro de tarea, inserto un registro en his_tarea con la operacion delete
            INSERT INTO his_tarea (fecha, operacion, usuario) VALUES (CURRENT_DATE, TG_OP, CURRENT_USER);       --inserto el nuevo valor
        RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

--2. Trigger

CREATE TRIGGER TR_FUNCION
AFTER INSERT OR UPDATE OF id_tarea, nombre_tarea, sueldo_maximo, sueldo_minimo OR DELETE
ON esq_peliculas_tarea
FOR EACH STATEMENT
EXECUTE PROCEDURE FN_FUNCION();