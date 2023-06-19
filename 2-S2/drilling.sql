--Tabla empresa
pk rut
nombre
direccion
telefono
correo
web

--Tabla cliente
pk rut
nombre
correo
direccion
celular
alta

--Tabla tipo_vehiculo
pk tipo_vehiculo_id
nombre

--Tabla marca
pk marca_id
nombre

--Tabla venta
pk folio
fechamonto
FK rut_cliente
FK vehiculo_id

--Tabla mantencion
pk mantencion_id
fechatrabajos_realizados
fk folio

--Tabla vehiculo
pk vehiculo_id
patente
modelo
color
precio
frecuencia_mantencion
fk marca_id
fk tipo_vehiculo_id

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