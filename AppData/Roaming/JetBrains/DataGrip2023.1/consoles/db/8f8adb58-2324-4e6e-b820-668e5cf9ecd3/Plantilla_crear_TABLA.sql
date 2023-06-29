CREATE TABLE nombre(
atributo TYPE,

PRIMARY KEY(),
FOREIGN KEY (id...) REFERENCES Tabla_de_la_PK(id...)
);

DROP TABLE IF EXISTS nombre_tabla CASCADE;