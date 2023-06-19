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

ALTER TABLE arriendo ADD CONSTRAINT fk_id_herramienta FOREIGN KEY(id_herramienta) REFERENCES herramienta(id_herramienta);

ALTER TABLE arriendo ADD CONSTRAINT fk_rut_cliente FOREIGN KEY(rut_cliente) REFERENCES cliente(rut);

--Inserte los datos de una empresa.
INSERT INTO empresa VALUES('11111111-1','Arrienda Herramientas','0123 Avenida Real',1234567890,'datosarriendo@herramientas.es','arrimientas.es');

--Inserte 5 herramientas.
INSERT INTO herramienta VALUES(1,'Taladro Electrico',10000),
                              (2,'Cierra Electrica',20000),
                              (3,'Pistola de Clavos',30000),
                              (4,'Lijadora',40000),
                              (5,'Serrucho Electrico',50000);

--Inserte 3 clientes.
INSERT INTO cliente VALUES('22222222-2','Juan Perez','j.perez@mail.com','1 Calle Uno',2222222222),
                          ('33333333-3','Juanita Sánches','j.sanches@mail.com','2 Calle Dos',3333333333),
                          ('44444444-4','Marcelo Ugarte','m.ugarte@mail.com','3 Calle Tres',4444444444);
						  
--Elimina el último cliente
DELETE FROM cliente WHERE rut = '44444444-4';


--Elimina la primera herramienta.
DELETE FROM herramienta WHERE id_herramienta = 1;


--Inserte 2 arriendos para cada cliente
INSERT INTO arriendo VALUES
	(1,'15/01/20',5,20000,'Eficacia en 5 dias o menos',2,'22222222-2'),
   	(2,'12/11/22',2,30000,'Eficacia en 2 dias o menos',3,'22222222-2'),
   	(3,'15/01/20',1,40000,'Eficacia en 1 dia',4,'33333333-3'),
   	(4,'12/11/22',3,40000,'Eficacia en solo 3 dias',5,'33333333-3');

--Modifique el correo electrónico del primer cliente.
UPDATE cliente SET correo = 'j_perez@mail.com' WHERE rut = '22222222-2';

--Liste todas las herramientas.
SELECT * FROM herramienta

--Liste los arriendos del segundo cliente.
SELECT * FROM arriendo WHERE rut_cliente = '33333333-3';

--Liste los clientes cuyo nombre contenga una a.
SELECT * FROM cliente WHERE nombre LIKE '%a%';

--Obtenga el nombre de la segunda herramienta insertada
SELECT nombre FROM herramienta WHERE id_herramienta = 2;

--Modifique los primeros 2 arriendos insertados con fecha 15/01/2020.
SELECT * FROM arriendo WHERE fecha = '15/01/20' LIMIT 2;
UPDATE arriendo SET garantia = 'Eficacia en 3 dias o menos' WHERE fecha = '15/01/20' AND folio = 1;
UPDATE arriendo SET garantia = 'Eficacia en 2 dia' WHERE fecha = '15/01/20' AND folio = 3;
--Otra opción que modifica primeras 2 de igual manera
UPDATE arriendo SET garantia = 'Nueva garantía' WHERE fecha = '2020-01-15' ORDER BY folio asc LIMIT 2;

--Liste Folio, Fecha y ValorDia de los arriendos de enero del 2020.
--Directo
SELECT folio, fecha, valor_dia FROM arriendo WHERE fecha = '15/01/20';
--Rango
SELECT folio, fecha, valor_dia FROM arriendo WHERE fecha BETWEEN '01/01/20' AND '31/01/20';
--Busqueda extrayendo mes y año
SELECT folio, fecha, valor_dia FROM arriendo WHERE EXTRACT(MONTH FROM fecha) = 01 AND EXTRACT(YEAR FROM fecha)= 2020;


--OTRAS CONSULTAS	
SELECT * FROM cliente;						  
SELECT * FROM herramienta;
SELECT * FROM empresa;
SELECT * FROM arriendo;