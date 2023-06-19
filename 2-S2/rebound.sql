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

----------------------------------------------------------------
--Consultas a la tabla "clientes":
----------------------------------------------------------------

--Obtener todos los clientes:
SELECT * FROM clientes;

--Obtener los clientes de una ciudad específica:
SELECT * FROM clientes WHERE ciudad = 'Ciudad1';

--Obtener el número total de clientes:
SELECT COUNT(*) FROM clientes;

--Obtener los clientes ordenados alfabéticamente por nombre:
SELECT * FROM clientes ORDER BY nombre_cliente;

--Obtener el cliente con el ID más alto:
SELECT * FROM clientes WHERE cliente_id = (SELECT MAX(cliente_id) FROM clientes);

--Obtener los clientes que tienen un nombre que comienza con "A":
SELECT * FROM clientes WHERE nombre_cliente LIKE 'P%';

--Obtener los clientes que pertenecen a una ciudad específica y tienen un nombre que contiene la palabra "Company":
SELECT * FROM clientes WHERE ciudad = 'Santiago' AND nombre_cliente LIKE '%Herman%';

--Obtener el cliente con el ID más bajo:
SELECT * FROM clientes WHERE cliente_id = (SELECT MIN(cliente_id) FROM clientes);

--Obtener el número de clientes por ciudad:
SELECT ciudad, COUNT(*) AS total_clientes FROM clientes GROUP BY ciudad;

--Obtener los clientes que no tienen órdenes asociadas:
SELECT c.* FROM clientes c LEFT JOIN ordenes o ON c.cliente_id = o.cliente_id WHERE o.cliente_id IS NULL;

--Obtener los clientes que tienen órdenes asociadas:
SELECT c.* FROM clientes c LEFT JOIN ordenes o ON c.cliente_id = o.cliente_id WHERE o.cliente_id IS NOT NULL;

----------------------------------------------------------------
--Consultas a la tabla "articulos":
----------------------------------------------------------------
--Obtener todos los artículos:
SELECT * FROM articulos;

--Obtener los artículos con un precio mayor a $50:
SELECT * FROM articulos WHERE precio > 50.00;

--Obtener el número total de artículos:
SELECT COUNT(*) FROM articulos;

--Obtener los artículos ordenados por nombre de forma descendente:
SELECT * FROM articulos ORDER BY nombre_articulo DESC;

--Obtener el artículo más caro:
SELECT * FROM articulos WHERE precio = (SELECT MAX(precio) FROM articulos);

--Obtener los artículos cuyo precio es mayor a 100:
SELECT * FROM articulos WHERE precio > 100.00;

--Obtener los artículos ordenados alfabéticamente por nombre en orden descendente:
SELECT * FROM articulos ORDER BY nombre_articulo DESC;

--Obtener el artículo más barato:
SELECT * FROM articulos WHERE precio = (SELECT MIN(precio) FROM articulos);

--Obtener el número total de artículos por rango de precios:
SELECT CASE
    WHEN precio < 50 THEN 'Menos de 50'
    WHEN precio >= 50 AND precio < 100 THEN 'Entre 50 y 100'
    ELSE 'Más de 100'
  END AS rango_precio,
  COUNT(*) AS total_articulos
FROM articulos
GROUP BY rango_precio;

--Obtener los artículos que no han sido incluidos en ninguna orden:
SELECT a.* FROM articulos a LEFT JOIN ordenes o ON a.codigo = o.codigo WHERE o.codigo IS NULL;

----------------------------------------------------------------
--Consultas a la tabla "ordenes":
----------------------------------------------------------------
--Obtener todas las órdenes:
SELECT * FROM ordenes;

--Obtener las órdenes realizadas en una fecha específica:
SELECT * FROM ordenes WHERE fecha = '2023-06-01';

--Obtener el número total de órdenes:
SELECT COUNT(*) FROM ordenes;

--Obtener las órdenes con una cantidad mayor a 10:
SELECT * FROM ordenes WHERE cantidad > 10;

--Obtener la orden más reciente:
SELECT * FROM ordenes WHERE fecha = (SELECT MAX(fecha) FROM ordenes);

--Obtener las órdenes realizadas en un rango de fechas específico:
SELECT * FROM ordenes WHERE fecha BETWEEN '2023-01-01' AND '2023-12-31';

--Obtener el número total de órdenes por cliente:
SELECT cliente_id, COUNT(*) AS total_ordenes FROM ordenes GROUP BY cliente_id;
SELECT cliente_id, COUNT(*) AS total_ordenes FROM ordenes GROUP BY cliente_id ORDER BY cliente_id asc;
SELECT cliente_id, COUNT(orden_id) AS total_ordenes FROM ordenes GROUP BY cliente_id ORDER BY cliente_id asc;


--Obtener la cantidad total de artículos vendidos en todas las órdenes:
SELECT SUM(cantidad) AS cantidad_total FROM ordenes;

--Obtener las órdenes con una cantidad superior a la media de cantidad de órdenes:
SELECT * FROM ordenes WHERE cantidad > (SELECT AVG(cantidad) FROM ordenes);

--Obtener las órdenes realizadas por clientes que pertenecen a una ciudad específica:
SELECT o.* FROM ordenes o INNER JOIN clientes c ON o.cliente_id = c.cliente_id WHERE c.ciudad = 'Santiago';

----------------------------------------------------------------
--Consultas combinadas entre tablas:
----------------------------------------------------------------
--Obtener todas las órdenes junto con la información del cliente y el artículo correspondiente:
SELECT o.orden_id, o.fecha, o.cantidad, c.nombre_cliente, a.nombre_articulo
FROM ordenes o
JOIN clientes c ON o.cliente_id = c.cliente_id
JOIN articulos a ON o.codigo = a.codigo;

--Obtener los clientes que han realizado órdenes de un artículo específico:
SELECT c.*
FROM clientes c
JOIN ordenes o ON c.cliente_id = o.cliente_id
WHERE o.codigo = '3786';

--Obtener el total gastado por cada cliente en todas las órdenes:
SELECT c.nombre_cliente, SUM(o.cantidad * a.precio) AS total_gastado
FROM clientes c
JOIN ordenes o ON c.cliente_id = o.cliente_id
JOIN articulos a ON o.codigo = a.codigo
GROUP BY c.nombre_cliente;

--Obtener los clientes que no han realizado ninguna orden:
SELECT c.*
FROM clientes c
LEFT JOIN ordenes o ON c.cliente_id = o.cliente_id
WHERE o.orden_id IS NULL;

--Obtener los artículos con su precio y el número de órdenes en las que se han vendido:
SELECT a.nombre_articulo, a.precio, COUNT(o.orden_id) AS num_ordenes
FROM articulos a
LEFT JOIN ordenes o ON a.codigo = o.codigo
GROUP BY a.nombre_articulo, a.precio;

--Obtener el nombre del cliente y el artículo más caro que han ordenado:
SELECT c.nombre_cliente, a.nombre_articulo, a.precio
FROM clientes c
JOIN ordenes o ON c.cliente_id = o.cliente_id
JOIN articulos a ON o.codigo = a.codigo
ORDER BY a.precio DESC
LIMIT 1;

--Obtener el nombre del cliente, el nombre del artículo y la fecha de las órdenes realizadas en una ciudad específica:
SELECT c.nombre_cliente, a.nombre_articulo, o.fecha
FROM clientes c
JOIN ordenes o ON c.cliente_id = o.cliente_id
JOIN articulos a ON o.codigo = a.codigo
WHERE c.ciudad = 'Santiago';

--Obtener el número total de órdenes y el precio promedio de los artículos por cliente:
SELECT c.cliente_id, COUNT(o.orden_id) AS total_ordenes, AVG(a.precio) AS precio_promedio
FROM clientes c
LEFT JOIN ordenes o ON c.cliente_id = o.cliente_id
LEFT JOIN articulos a ON o.codigo = a.codigo
GROUP BY c.cliente_id;

--Obtener los clientes y los artículos que han ordenado, mostrando NULL para los clientes sin órdenes y los artículos sin órdenes asociadas:
SELECT c.nombre_cliente, a.nombre_articulo
FROM clientes c
FULL JOIN ordenes o ON c.cliente_id = o.cliente_id
FULL JOIN articulos a ON o.codigo = a.codigo;

--Obtener los clientes que han realizado una orden de un artículo específico, junto con el nombre del artículo y la cantidad de órdenes realizadas:
SELECT c.nombre_cliente, a.nombre_articulo, COUNT(o.orden_id) AS num_ordenes
FROM clientes c
JOIN ordenes o ON c.cliente_id = o.cliente_id
JOIN articulos a ON o.codigo = a.codigo
WHERE a.nombre_articulo = 'Red'
GROUP BY c.nombre_cliente, a.nombre_articulo;


----------------------------------------------------------------
--Explicando join, left join, right join, full join:
----------------------------------------------------------------
INNER JOIN: El INNER JOIN se utiliza para combinar las filas 
de dos o más tablas en función de una condición de coincidencia. 
Devuelve solo las filas que tienen una coincidencia en ambas tablas.

LEFT JOIN (o LEFT OUTER JOIN): El LEFT JOIN se utiliza para combinar todas las filas 
de la tabla izquierda con las filas coincidentes de la tabla derecha. 
Si no hay una coincidencia en la tabla derecha, se devolverá NULL para los campos de la tabla derecha.

RIGHT JOIN (o RIGHT OUTER JOIN): El RIGHT JOIN se utiliza para combinar todas las filas 
de la tabla derecha con las filas coincidentes de la tabla izquierda.
Si no hay una coincidencia en la tabla izquierda, se devolverá NULL para los campos de la tabla izquierda.

FULL JOIN (o FULL OUTER JOIN): El FULL JOIN se utiliza para combinar todas las filas de ambas tablas, 
incluyendo las filas que no tienen coincidencias en la otra tabla. 
Si no hay una coincidencia, se devolverá NULL para los campos correspondientes de la tabla opuesta.

Es importante tener en cuenta que los operadores OUTER JOIN (LEFT OUTER JOIN, RIGHT OUTER JOIN y FULL OUTER JOIN) 
son compatibles en PostgreSQL y se pueden utilizar para realizar consultas que involucren combinaciones externas izquierdas, derechas o completas. 
El operador OUTER es opcional y se puede omitir en las cláusulas JOIN. Por ejemplo, LEFT JOIN y LEFT OUTER JOIN son equivalentes en PostgreSQL.

--Join:

SELECT c.nombre_cliente, o.orden_id, a.nombre_articulo
FROM clientes c
JOIN ordenes o ON c.cliente_id = o.cliente_id
JOIN articulos a ON o.codigo = a.codigo;

--Left Outer Join:
SELECT c.nombre_cliente, o.orden_id, a.nombre_articulo
FROM clientes c
LEFT JOIN ordenes o ON c.cliente_id = o.cliente_id
LEFT JOIN articulos a ON o.codigo = a.codigo;

--Right Outer Join:
SELECT c.nombre_cliente, o.orden_id, a.nombre_articulo
FROM clientes c
RIGHT JOIN ordenes o ON c.cliente_id = o.cliente_id
RIGHT JOIN articulos a ON o.codigo = a.codigo;

--Full Outer Join:
SELECT c.nombre_cliente, o.orden_id, a.nombre_articulo
FROM clientes c
FULL JOIN ordenes o ON c.cliente_id = o.cliente_id
FULL JOIN articulos a ON o.codigo = a.codigo;