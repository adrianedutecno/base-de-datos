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


--Obtener el nombre del cliente y el artículo más caro que han ordenado
--Obtener el nombre del cliente, el nombre del artículo y la fecha de las órdenes realizadas en una ciudad específica
--Obtener el número total de órdenes y el precio promedio de los artículos por cliente
--Obtener los clientes y los artículos que han ordenado, mostrando NULL para los clientes sin órdenes y los artículos sin órdenes asociadas
--Obtener los clientes que han realizado una orden de un artículo específico, junto con el nombre del artículo y la cantidad de órdenes realizadas
