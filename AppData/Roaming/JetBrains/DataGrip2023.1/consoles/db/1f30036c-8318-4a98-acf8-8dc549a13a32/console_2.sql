INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (1, 'Papel', 'Rivadavia');
SELECT * FROM p5p1e1_articulo;

INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('BR', 234, 'Sarasa');
SELECT * FROM p5p1e1_palabra;

INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (2, 'BR', 234);
SELECT * FROM p5p1e1_contiene;

