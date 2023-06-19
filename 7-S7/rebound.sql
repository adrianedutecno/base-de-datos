GRANT ALL PRIVILEGES ON DATABASE s7_rebound TO postgres;

BEGIN;

SAVEPOINT uno;

CREATE TABLE empresa(
rut VARCHAR(12) PRIMARY KEY,
nombre VARCHAR(30),
direccion VARCHAR(255),
telefono VARCHAR(11),
correo VARCHAR(255),
web VARCHAR(40)
);

CREATE TABLE cliente(
rut VARCHAR(9) PRIMARY KEY,
nombre VARCHAR(30),
correo VARCHAR(255),
direccion VARCHAR(255),
celular VARCHAR(11),
alta BOOLEAN
);

CREATE TABLE tipo_vehiculo(
tipo_vehiculo_id SERIAL PRIMARY KEY,
nombre VARCHAR(255)
);

CREATE TABLE marca(
marca_id SERIAL PRIMARY KEY,
nombre VARCHAR(255)
);

CREATE TABLE vehiculo(
vehiculo_id SERIAL PRIMARY KEY,
patente VARCHAR(6),
modelo VARCHAR(255),
color VARCHAR(255),
PRECIO MONEY,
frecuencia_mantencion INT,
marca_id INT,
tipo_vehiculo_id INT
);

CREATE TABLE venta(
folio SERIAL PRIMARY KEY,
fecha DATE,
monto INT,
rut_cliente VARCHAR(9),
vehiculo_id INT
);

CREATE TABLE mantencion(
mantencion_id SERIAL PRIMARY KEY,
fecha DATE,
trabajos_realizados VARCHAR(255),
folio INT
);

--sección de insección de datos
SAVEPOINT dos;

--Inserte los datos de una empresa.
INSERT INTO empresa VALUES('9999999999-9','Ono-fio', 'Santiago','9623659', 'onofrio@onofrio.cl', 'onofrio.com');
SELECT * FROM empresa;

SAVEPOINT tres;
--Inserte 2 tipos de vehículo.
INSERT INTO tipo_vehiculo(nombre) VALUES ('Carga');
INSERT INTO tipo_vehiculo(nombre) VALUES ('Transporte');
SELECT * FROM tipo_vehiculo;

SAVEPOINT cuatro;
--Inserte 3 clientes.
INSERT INTO cliente VALUES('1345678-1', 'Fulanito','fulanito@fulanito.cl','Santiago','956854521', true);
INSERT INTO cliente VALUES('7563214-2', 'Perensejo','perensejo@perensejo.cl','Coquimbo','945213632', false);
INSERT INTO cliente VALUES('5231451-k', 'Rodrigo','rodrigo@rodrigo.cl','Concon','95232526', true);
INSERT INTO cliente VALUES('5231452-1', 'Karla','karla@karla.cl','Chiloe','95232522', true);
INSERT INTO cliente VALUES('5231453-2', 'Lorena','lorena@lorena.cl','Chillan','95232523', true);

SELECT * FROM cliente;

SAVEPOINT cinco;
--Inserte 2 marcas
INSERT INTO marca(nombre) VALUES('Hyundai');
INSERT INTO marca(nombre) VALUES('Toyota');
SELECT * FROM marca;

SAVEPOINT seis;
--Inserte 5 vehículos
INSERT INTO vehiculo(patente, modelo, color, precio, frecuencia_mantencion, marca_id, tipo_vehiculo_id)
VALUES('963PLK','M3','Negro', 10000000,6, 1,2);

INSERT INTO vehiculo(patente, modelo, color, precio, frecuencia_mantencion, marca_id, tipo_vehiculo_id)
VALUES('875436','M5','Rosa', 6000000,3, 2,1);

INSERT INTO vehiculo(patente, modelo, color, precio, frecuencia_mantencion, marca_id, tipo_vehiculo_id)
VALUES('741253','H7','Gris', 9000000,12, 2,2);

INSERT INTO vehiculo(patente, modelo, color, precio, frecuencia_mantencion, marca_id, tipo_vehiculo_id)
VALUES('952137','P8','Dorado', 5000000,5, 1,1);

INSERT INTO vehiculo(patente, modelo, color, precio, frecuencia_mantencion, marca_id, tipo_vehiculo_id)
VALUES('746328','T6','Blanco', 15000000,2, 2,2);
SELECT * FROM vehiculo;

SAVEPOINT siete;
--Inserte 1 venta para cada cliente.
INSERT INTO venta(fecha, monto, rut_cliente, vehiculo_id)
VALUES('2022-01-23', 10000000, '1345678-1', 1);

INSERT INTO venta(fecha, monto, rut_cliente, vehiculo_id)
VALUES('2022-05-24', 6000000, '7563214-2', 2);

INSERT INTO venta(fecha, monto, rut_cliente, vehiculo_id)
VALUES('2022-02-15', 5000000, '5231451-k', 4);
SELECT * FROM venta;



SAVEPOINT ocho;

ALTER TABLE mantencion ADD CONSTRAINT fk_folio
FOREIGN KEY(folio) REFERENCES venta(folio);

ALTER TABLE vehiculo ADD CONSTRAINT fk_marca_id
FOREIGN KEY(marca_id) REFERENCES marca(marca_id);

ALTER TABLE vehiculo ADD CONSTRAINT fk_tipo_vehiculo_id
FOREIGN KEY(tipo_vehiculo_id) REFERENCES tipo_vehiculo(tipo_vehiculo_id);

ALTER TABLE venta ADD CONSTRAINT fk_rut_cliente 
FOREIGN KEY(rut_cliente) REFERENCES cliente(rut);

ALTER TABLE venta ADD CONSTRAINT fk_vehiculo_id
FOREIGN KEY(vehiculo_id) REFERENCES vehiculo(vehiculo_id);

SELECT * FROM vehiculo;
SELECT * FROM mantencion;
SELECT * FROM venta;
SELECT * FROM cliente;
SELECT * FROM empresa;
SELECT * FROM tipo_vehiculo;

-- Listar los clientes sin ventas por medio de una subconsulta.
SELECT nombre FROM cliente
WHERE rut NOT IN (SELECT rut_cliente FROM venta);

SELECT rut_cliente FROM venta;

--Listar todas ventas con las siguientes columnas: Folio, Fecha, Monto, NombreCliente, RutCliente
SELECT
    v.folio,
    v.fecha,
    v.monto,
    c.nombre AS NombreCliente,
    c.rut AS RutCliente
FROM
    venta v
JOIN
    cliente c ON v.rut_cliente = c.rut
WHERE
    EXISTS (
        SELECT
            1
        FROM
            venta
        WHERE
            v.folio = venta.folio
    );
	
--Clasificar los clientes según la siguiente tabla
SELECT rut_cliente,monto,
CASE
	WHEN monto BETWEEN 0 AND 1000000 THEN 'Standar'
	WHEN monto BETWEEN 1000001 AND 3000000 THEN 'Gold'
	WHEN monto = 3000001 THEN 'Premium'	
	WHEN monto > 3000001 THEN 'Premium'
	ELSE 'No califica'
END AS Clasificacion	
FROM venta;

SELECT
    rut_cliente,
    monto,
    CASE
        WHEN monto <= 1000000 THEN 'Standard'
        WHEN monto > 1000000 AND alta <= 3000000 THEN 'Gold'
        WHEN monto > 3000000 THEN 'Premium'
    END AS clasificacion
FROM
    venta;

--Por medio de una subconsulta, listar las ventas con la marca del vehículo más vendido.
SELECT v.*, m.nombre FROM venta as v
JOIN vehiculo as veh
ON veh.vehiculo_id = v.vehiculo_id
JOIN marca as m
ON m.marca_id=veh.marca_id
WHERE veh.marca_id =
	(SELECT veh.marca_id FROM vehiculo as veh
	JOIN venta as v
	ON veh.vehiculo_id = v.vehiculo_id
	GROUP BY veh.marca_id
	ORDER BY COUNT(*) DESC LIMIT 1);



--------------------------------------------------------
SELECT
    v.vehiculo_id,
    v.patente,
    v.modelo,
    v.color,
    v.precio,
    v.frecuencia_mantencion
FROM
    vehiculo v
WHERE
    NOT EXISTS (
        SELECT 1
        FROM venta ve
        WHERE ve.vehiculo_id = v.vehiculo_id
    );

ROLLBACK;
COMMIT;