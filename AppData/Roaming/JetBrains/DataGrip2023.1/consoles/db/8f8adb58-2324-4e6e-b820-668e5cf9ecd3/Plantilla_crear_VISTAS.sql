CREATE VIEW NOMBRE AS
SELECT...;
--si tiene la pk esta tabla o la que invoca, es actualizable

--ACTUALIZABLES
--Con check local
--La actualización solo se propagará a la vista si la fila que se actualiza existe en la vista.
--Si la fila que se está actualizando no existe en la vista, se ignorará la actualización.

CREATE VIEW NOMBRE AS
SELECT...
WITH LOCAL CHECK OPTION;

--Con check cascaded
--La actualización se propagará a la vista incluso si la fila que se actualiza no existe en la vista.
--Esto podría crear nuevas filas en la vista si la fila que se actualiza no existe en la vista.

CREATE VIEW NOMBRE AS
SELECT...
WITH CASCADED CHECK OPTION;