Ordenes
IdOrden,Fecha,IdCliente,Cliente,Ciudad,Código,Articulo,Cantidad,Precio

Primera Forma Normal (1FN):La 1FN establece que cada columna de una tabla debe contener un solo valor y no debe haber duplicación de datos.
-------1FN
Tabla ordenes
idOrden
fecha

Tabla clientes
idCliente
nombre_cliente
ciudad

Tabla articulos
codigo
nombre_articulo
cantidad 
precio

Segunda Forma Normal (2FN):La 2FN establece que una tabla debe cumplir con la 1FN y que cada columna no clave(ni pk, ni fk) debe depender completamente de la clave primaria.
--------2FN
Tabla ordenes
PK idOrden
fecha
FK idCliente

Tabla clientes
PK idCliente
nombre_cliente
ciudad

Tabla articulos
PK codigo
nombre_articulo 
precio

Tabla detalle_ordenes
PK idDetalleOrden
cantidad
FK idOrden
FK codigo


Tercera Forma Normal (3FN):La 3FN establece que una tabla debe cumplir con la 2FN y que no debe haber dependencias transitivas.
--------3FN
Tabla ordenes
PK orden_id
fecha
FK cliente_id

Tabla clientes
PK cliente_id
nombre_cliente
ciudad

Tabla articulos
PK codigo
nombre_articulo 
precio

Tabla detalle_ordenes
PK detalle_orden_id
cantidad
FK orden_id
FK codigo


CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(50),
    ciudad VARCHAR(50)  
);
CREATE TABLE articulos (
    codigo VARCHAR(10) PRIMARY KEY,
    nombre_articulo VARCHAR(50),
    precio DECIMAL(10,2)    
);
CREATE TABLE ordenes (
    orden_id INT,
    fecha DATE,
    cantidad INT,
    codigo VARCHAR(10),
    cliente_id INT,
    CONSTRAINT fk_cliente_id FOREIGN KEY(cliente_id) 
    REFERENCES clientes(cliente_id),
    CONSTRAINT fk_codigo FOREIGN KEY(codigo) 
    REFERENCES articulos(codigo)
);
INSERT INTO clientes (nombre_cliente, ciudad) VALUES
('Martin', 'Santiago'),
('Herman', 'Valparaíso'),
('Pedro', 'Concepción');
select * from clientes;
INSERT INTO articulos (codigo, nombre_articulo, precio) 
VALUES
('3786', 'Red', 35.00),
('4011', 'Raqueta', 65.00),
('9132', 'Paq-3', 4.75),
('5794', 'Paq-6', 5.00),
('3141', 'Funda', 10.00);
select * from articulos;
INSERT INTO ordenes 
(orden_id, fecha, cantidad, codigo, cliente_id) 
VALUES
(2301, '2020-02-23', 3, '3786', 1),
(2301, '2020-02-23', 6, '4011', 1),
(2301, '2020-02-23', 8, '9132', 1),
(2302, '2020-02-25', 4, '5794', 2),
(2303, '2020-02-27', 2, '4011', 3),
(2303, '2020-02-27', 2, '3141', 3);
select * from ordenes;