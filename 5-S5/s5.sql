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
							  
--si no estoy contento o sucede un error se regresa a pun punto de guardado
ROLLBACK TO SAVEPOINT primero;
ROLLBACK TO SAVEPOINT segundo;

--si estoy contento y sucede todo bien, realizamos un commit
COMMIT;

SELECT * FROM herramienta;
SELECT * FROM cliente;

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

SAVEPOINT tercero;
--Elimina el último cliente
DELETE FROM cliente WHERE rut = '44444444-4';

SAVEPOINT cuarto;
--Elimina la primera herramienta.
DELETE FROM herramienta WHERE id_herramienta = 1;

SAVEPOINT quinto;
--Inserte 2 arriendos para cada cliente
INSERT INTO arriendo VALUES
	(1,'15/01/20',5,20000,'Eficacia en 5 dias o menos',2,'22222222-2'),
   	(2,'12/11/22',2,30000,'Eficacia en 2 dias o menos',3,'22222222-2'),
   	(3,'15/01/20',1,40000,'Eficacia en 1 dia',4,'33333333-3'),
   	(4,'12/11/22',3,40000,'Eficacia en solo 3 dias',5,'33333333-3');
	
SAVEPOINT sexto;	
--Modifique el correo electrónico del primer cliente.
UPDATE cliente SET correo = 'j_perez@mail.com' WHERE rut = '22222222-2';
	
RELEASE SAVEPOINT quinto;

--si no estoy contento o sucede un error se regresa a punto de guardado
ROLLBACK TO SAVEPOINT primero;
ROLLBACK TO SAVEPOINT segundo;
ROLLBACK TO SAVEPOINT tercero;
ROLLBACK TO SAVEPOINT cuarto;
ROLLBACK TO SAVEPOINT quinto;
ROLLBACK TO SAVEPOINT sexto;
--si estoy contento y sucede todo bien, realizamos un commit
COMMIT;

--no estoy contento con el estado, se regresa completamente al último estado valido
ROLLBACK;
SELECT * FROM herramienta;
SELECT * FROM cliente;
SELECT * FROM arriendo;