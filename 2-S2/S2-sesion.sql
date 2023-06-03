-- tabla categorias
-- PK categoria_id, nombre

-- tabla productos
-- PK producto_id, nombre, precio, FK categoria_id

-- Tabla con PK
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Tabala con PK y FK
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR (50),
    precio INT,
    categoria_id INT, 
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

-- Insertar valores en tabla categorias con referencia a la columna nombre

INSERT INTO categorias (nombre) VALUES ('Electronica');
INSERT INTO categorias (nombre) VALUES ('Ropa');
INSERT INTO categorias (nombre) VALUES ('Hogar');

-- Mostrar todas las columnas y campos en tabla categorias
SELECT * FROM categorias;

-- Insertar valores en tabla productos
INSERT INTO productos (nombre, precio, categoria_id) VALUES 
('Telefono',12000, 1),
('Televisor', 500000, 1),
('Pantalon', 1000, 2),
('Polera', 500, 2),
('Tetera', 2500, 3),
('Mesa', 40000, 3);

-- Mostrar todas las columnas y campos en tabla productos
SELECT * FROM productos;

-- Punto de guardado permanente
COMMIT;
DROP TABLE productos;
DROP TABLE categorias

--Tipos de datos
--https://www.postgresql.org/docs/current/datatype.html