----------------------------------------------------
--Variables de entorno del sistema windows
--System enviroment variables
----------------------------------------------------
C:\Program Files\PostgreSQL\15\bin
C:\Program Files\PostgreSQL\15\lib

----------------------------------
--Conectar desde cualquier parte
----------------------------------

psql -U username -W -d database_name

----------------------------------
--pasos para conectar a psql shell
----------------------------------
ruta: localhost
enter
database: postgres
enter
port: 5432
enter
user: postgres
enter
password

----------------------------------
--comandos psql shell
----------------------------------
\l | listar
\? | ayuda
\dt | listar tablas éxistentes
\du | listar usuarios roles y atributos
\conninfo | detalles del usuario conectado
\c database_name | cambiar de base de datos
\q | salir del psql shell
\! | obtener info del sistema y salir sin cerrar psql shell

----------------------------------
--Crear usuarios
----------------------------------
CREATE USER username WITH PASSWORD 'password';
DROP USER username;
GRANT ALL PRIVILEGES ON DATABASE database TO username;
GRANT _PRIVILEGES_ ON DATABASE database TO username;
REVOKE ALL PRIVILEGES ON DATABASE database FROM username;
----------------------------------
--Crear base de datos
----------------------------------
CREATE DATABASE database_name;
DROP DATABASE database_name;
