GRANT ALL PRIVILEGES ON DATABASE s7_drilling TO postgres;

BEGIN;
CREATE TABLE empresa(
	rut VARCHAR(10) PRIMARY KEY,
	nombre VARCHAR(120),
	direccion VARCHAR(120),
	telefono VARCHAR(15),
	correo VARCHAR(80),
	web VARCHAR(50)
);

CREATE TABLE herramienta(
	id_herramienta INT PRIMARY KEY,
	nombre VARCHAR(120),
	precio_dia MONEY
);

CREATE TABLE cliente(
	rut VARCHAR(10) PRIMARY KEY,
	nombre VARCHAR(120),
	correo VARCHAR(80),
	direccion VARCHAR(120),
	celular VARCHAR(15)
);

CREATE TABLE arriendo(
	folio INT PRIMARY KEY,
	fecha DATE,
	dias INT,
	valor_dia INT,
	garantia VARCHAR(30),
	id_herramienta INT,
	rut_cliente VARCHAR(10)
);

ALTER TABLE arriendo 
ADD CONSTRAINT fk_id_herramienta 
FOREIGN KEY(id_herramienta) 
REFERENCES herramienta(id_herramienta);

ALTER TABLE arriendo 
ADD CONSTRAINT fk_rut_cliente 
FOREIGN KEY(rut_cliente) 
REFERENCES cliente(rut);

COMMIT;
SELECT * FROM empresa;
SELECT * FROM herramienta;

	--iniciando una transacción
BEGIN;

--asegurando el primer estado creando un punto de estado
--SAVEPOINT nombre_save_point;
SAVEPOINT primero;

--Inserte 5 herramientas.
INSERT INTO herramienta VALUES(1,'Taladro Electrico',10000),
                              (2,'Cierra Electrica',20000),
                              (3,'Pistola de Clavos',30000),
                              (4,'Lijadora',40000),
                              (5,'Serrucho Electrico',50000);

SAVEPOINT segundo;

--Inserte 3 clientes.
INSERT INTO cliente VALUES('22222222-2','Juan Perez','j.perez@mail.com','1 Calle Uno',2222222222),
                          ('33333333-3','Juanita Sánches','j.sanches@mail.com','2 Calle Dos',3333333333),
                          ('44444444-4','Marcelo Ugarte','m.ugarte@mail.com','3 Calle Tres',4444444444);							  
							  

--Inserte 3 clientes.
INSERT INTO cliente VALUES('22222222-2','Juan Perez','j.perez@mail.com','1 Calle Uno',2222222222),
                          ('33333333-3','Juanita Sánches','j.sanches@mail.com','2 Calle Dos',3333333333),
                          ('44444444-4','Marcelo Ugarte','m.ugarte@mail.com','3 Calle Tres',4444444444);
						  
--Inserte 2 arriendos para cada cliente
INSERT INTO arriendo VALUES
	(1,'15/01/20',5,20000,'Eficacia en 5 dias o menos',2,'22222222-2'),
   	(2,'12/11/22',2,30000,'Eficacia en 2 dias o menos',3,'22222222-2'),
   	(3,'15/01/20',1,40000,'Eficacia en 1 dia',4,'33333333-3'),
   	(4,'12/11/22',3,40000,'Eficacia en solo 3 dias',5,'33333333-3');
	
INSERT INTO empresa VALUES('11111111-1','Arrienda Herramientas','0123 Avenida Real',1234567890,'datosarriendo@herramientas.es','arrimientas.es');

--si estoy contento y sucede todo bien, realizamos un commit
COMMIT;

ROLLBACK;

SELECT * FROM herramienta;
SELECT * FROM cliente;

--Listar los clientes sin arriendos por medio de una subconsulta.
SELECT nombre FROM cliente
WHERE rut NOT IN (SELECT rut_cliente FROM arriendo);

--Listar todos los arriendos con las siguientes columnas: 
--Folio, Fecha, Dias, ValorDia, NombreCliente, RutCliente.
SELECT a.folio, a.fecha, a.dias, a.valor_dia, c.nombre, c.rut FROM arriendo as a
JOIN cliente as c
ON a.rut_cliente = c.rut
WHERE EXISTS(SELECT 1 FROM arriendo WHERE a.folio = arriendo.folio);

--Clasificar los clientes según la siguiente tabla:0-1 bajo 2-3 medio mas de 3 alto veces qeu ha arrendado
select * from arriendo;

SELECT c.rut, c.nombre, COUNT (a.folio) AS cantidad_arriendos,
CASE
    WHEN COUNT(a.folio) <= 1 THEN 'bajo'
    WHEN COUNT (a.folio) > 1 AND (a.folio) < 3 THEN 'medio'
    WHEN COUNT(a.folio) >= 3 THEN 'alto'
    END AS clasificacion
FROM cliente as c
LEFT JOIN arriendo as a
ON c.rut= a.rut_cliente
GROUP BY c.rut, c.nombre, a.folio;

--Por medio de una subconsulta, listar los clientes con el nombre de la herramienta más arrendada.
SELECT c.*, h.nombre FROM cliente as c
JOIN  arriendo as a
ON  c.rut = a.rut_cliente 
JOIN herramienta as h
ON h.id_herramienta = a.id_herramienta
WHERE a.id_herramienta IN
	(SELECT a.id_herramienta FROM herramienta as h
	JOIN arriendo as a
	ON h.id_herramienta = a.id_herramienta
	GROUP BY a.id_herramienta);
	
SELECT c.*, h.nombre FROM cliente as c
JOIN  arriendo as a
ON  c.rut = a.rut_cliente 
JOIN herramienta as h
ON h.id_herramienta = a.id_herramienta
WHERE a.id_herramienta IN
	(SELECT a.id_herramienta FROM herramienta as h
	JOIN arriendo as a
	ON h.id_herramienta = a.id_herramienta
	GROUP BY a.id_herramienta
	ORDER BY COUNT(*) DESC LIMIT 10);