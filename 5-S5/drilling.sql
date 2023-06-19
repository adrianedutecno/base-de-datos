tabla reparto 
id foranea peliculas
actor

tabla peliculas
id 
pelicula
estreno
Director

BEGIN;
SAVEPOINT uno;
CREATE TABLE peliculas(
    id INT PRIMARY KEY,
    pelicula VARCHAR(255),
    estreno INT,
    director VARCHAR(255)
);

CREATE TABLE reparto(
    id_pelicula INT,
    actor VARCHAR(255),
    FOREIGN KEY (id_pelicula) REFERENCES peliculas(id)
);

COMMIT;

\COPY "peliculas" FROM 'C:\Users\usuario\peliculas.csv' WITH CSV;

\COPY "reparto" FROM 'C:\Users\usuario\peliculas\reparto.csv' WITH CSV;

--Listar todos los actores que aparecen en la película "Titanic", indicando el título de la película,
--año de estreno, director y todo el reparto
--sin alias
SELECT titulo, estreno, director, actor FROM peliculas 
JOIN reparto 
ON peliculas.id_pelicula = reparto.id_pelicula
WHERE titulo = 'Titanic';
--con alias
SELECT p.titulo, p.estreno, p.director, r.actor FROM peliculas AS p 
JOIN reparto AS r
ON p.id_pelicula = r.id_pelicula
WHERE titulo = 'Titanic';

--Listar los 10 directores más populares, indicando su nombre y cuántas películas aparecen 
--en el top 100
SELECT * FROM peliculas;

--SELECT director COUNT FROM pelicula

SELECT p.director, COUNT(*) AS peliculas_en_top_100
FROM peliculas p
WHERE p.id_pelicula IN (
    SELECT DISTINCT id_pelicula
    FROM reparto
)
GROUP BY p.director
ORDER BY peliculas_en_top_100 DESC
LIMIT 10;

SELECT p.director, COUNT(*) AS peliculas_en_top_100
FROM peliculas p
WHERE p.id_pelicula IN (
    SELECT id_pelicula
    FROM peliculas
	ORDER BY estreno DESC LIMIT 100
)
GROUP BY p.director
ORDER BY peliculas_en_top_100 DESC
LIMIT 10;


--Indicar cuántos actores distintos hay
SELECT * FROM reparto;
SELECT COUNT(DISTINCT actor) AS Total_Distintos FROM reparto;
SELECT actor, COUNT(*) as contador FROM reparto GROUP BY actor;

--Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos), ordenadas 
--por título de manera ascendente
SELECT titulo, estreno FROM peliculas WHERE estreno BETWEEN 1990 AND 1999 
ORDER BY titulo ASC;

-- Listar los actores de la película más nueva
SELECT r.actor, p.titulo, p.estreno  FROM peliculas AS p 
JOIN reparto AS r
ON p.id_pelicula = r.id_pelicula
ORDER BY estreno DESC;

SELECT r.actor, p.titulo, p.estreno  FROM peliculas AS p 
JOIN reparto AS r
ON p.id_pelicula = r.id_pelicula
WHERE estreno = (SELECT MAX(estreno) FROM peliculas);

SELECT r.actor, p.titulo
FROM reparto r
JOIN peliculas p ON p.id_pelicula = r.id_pelicula
WHERE p.id_pelicula = (
    SELECT id_pelicula
    FROM peliculas
    ORDER BY estreno DESC
	LIMIT 1
);

-- Inserte los datos de una nueva película solo en memoria, y otra película en el disco duro.
BEGIN;
SAVEPOINT uno;

INSERT INTO peliculas(id_pelicula, titulo, estreno, director) 
VALUES (101, 'The Father',2021, 'Florian Zeller');
DELETE FROM peliculas WHERE id_pelicula = 101;

SAVEPOINT dos;

INSERT INTO peliculas(id_pelicula, titulo, estreno, director) 
VALUES (102, 'The Imitation',2013, 'Morten Tyldum');

ROLLBACK TO SAVEPOINT dos;

COMMIT;

--Actualice 5 directores utilizando ROLLBACK

BEGIN;

UPDATE peliculas SET director = CASE director
	WHEN 'Robert Zemeckis' THEN 'Bob esponja'
	WHEN 'James Cameron' THEN 'Mario Bros'
	WHEN 'Francis Ford Coppola' THEN 'Luigi Bros'
	WHEN 'Ridley Scott' THEN 'Naruto Uchiha'
	WHEN 'Peter Jackson' THEN 'Patricio Estrella'
	ELSE director
	END;
	
UPDATE peliculas SET director = CASE 
	WHEN director LIKE 'Robert Zemeckis' THEN 'Bob esponja'
	WHEN director LIKE 'James Cameron' THEN 'Mario Bros'
	WHEN director LIKE 'Francis Ford Coppola' THEN 'Luigi Bros'
	WHEN director LIKE 'Ridley Scott' THEN 'Naruto Uchiha'
	WHEN director LIKE 'Peter Jackson' THEN 'Patricio Estrella'
	ELSE director
	END;

ROLLBACK;

--Inserte 3 actores a la película “Rambo” utilizando SAVEPOINT
BEGIN;
SAVEPOINT uno;

INSERT INTO reparto VALUES (72,'Patricio Estrella'),(72, 'Natalia Romanini'), (72, 'Luigi Bros');

ROLLBACK TO SAVEPOINT uno;
SELECT * FROM reparto WHERE id_pelicula = 72;

COMMIT;

--Elimina las películas estrenadas el año 2008 solo en memoria.
BEGIN;
--desactivar las claves foraneas para poder eliminar
ALTER TABLE reparto DISABLE TRIGGER ALL;
ALTER TABLE peliculas DISABLE TRIGGER ALL;

--reactivar las claves foraneas 
ALTER TABLE reparto ENABLE TRIGGER ALL;
ALTER TABLE peliculas ENABLE TRIGGER ALL;

DELETE FROM peliculas WHERE estreno = 2008;

SELECT * FROM peliculas WHERE estreno = 2008;

ROLLBACK;

-- Inserte 2 actores para cada película estrenada el 2001.

SELECT * FROM peliculas WHERE estreno = 2001;
BEGIN;

INSERT INTO reparto VALUES (55,'Patricio Estrella'),(55,'Alex Estrella'),
(78,'Javier Estrella'), (78,'Eduardo Estrella'), (94,'Natalia Estrella'), (94,'Jose Estrella'),
(99,'Fulanito Estrella'), (99,'Perensejo Estrella'), (13,'Pedro Estrella'), (13,'Manuel Estrella'),
(16,'Jesus Estrella'), (16,'Miguel Estrella');

BEGIN;
INSERT INTO reparto (id_pelicula, actor)
SELECT id, actor
FROM (
	VALUES
	(55,'Patricio Estrella'),
	(55,'Alex Estrella'),
	(78,'Javier Estrella'), 
	(78,'Eduardo Estrella'), 
	(94,'Natalia Estrella'), 
	(94,'Jose Estrella'),
	(99,'Fulanito Estrella'), 
	(99,'Perensejo Estrella'), 
	(13,'Pedro Estrella'), 
	(13,'Manuel Estrella'),
	(16,'Jesus Estrella'), 
	(16,'Miguel Estrella')
) AS data(id, actor)
JOIN peliculas ON peliculas.id_pelicula = data.id;

SELECT r.actor, p.titulo, p.estreno  FROM peliculas AS p 
JOIN reparto AS r
ON p.id_pelicula = r.id_pelicula
WHERE estreno = 2001;

ROLLBACK;