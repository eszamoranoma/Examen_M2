-- Para este ejercicio utilizaremos la bases de datos Sakila que hemos estado utilizando durante el repaso de SQL. Es una base de datos de ejemplo que una tienda de alquiler de películas. 
-- Contiene tablas como film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre otras. 
-- Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan para realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas.


USE sakila;

-- 1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title Película
FROM film;

-- 2.Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title "Películas PG-13"
FROM film
WHERE rating = "PG-13";

-- 3.Encuentra el título y la descripción de todas las películas que contengan la cadena de caracteres "amazing" en su descripción.

SELECT title Título, description Descripción
FROM film
WHERE description LIKE "%amazing%";

-- 4.Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title "Películas (+120min)" 
FROM film
WHERE length > 120;

-- 5.Recupera los nombres y apellidos de todos los actores.

SELECT first_name Nombre, last_name Apellido
FROM actor;

-- 6.Encuentra el nombre y apellidos de los actores que tengan "Gibson" en su apellido.

SELECT first_name Nombre, last_name Apellido
FROM actor
WHERE last_name LIKE "%Gibson%";

-- 7.Encuentra los nombres y apellidos de los actores que tengan un actor_id entre 10 y 20.

SELECT actor_id, first_name Nombre, last_name Apellido
FROM actor
WHERE actor_id BETWEEN 10 AND 20; 

-- 8.Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title "Películas (no R ni PG-13)" 
FROM film
WHERE rating NOT IN ("PG-13", "R");

-- 9.Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating Clasificación, COUNT(title) "Nº Películas"
FROM film
GROUP BY rating;

-- 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id ID, c.first_name Nombre, c.last_name Apellido, COUNT(r.rental_id) "Total Películas Alquiladas"
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY ID, Nombre, Apellido;

-- 11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name Categoría, COUNT(r.rental_id) "Total Películas Alquiladas"
FROM category c
LEFT JOIN film_category fc 
ON c.category_id = fc.category_id
LEFT JOIN film f           
ON fc.film_id = f.film_id
LEFT JOIN inventory i      
ON f.film_id = i.film_id
LEFT JOIN rental r         
ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- 12.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating Categoría, AVG(length) "Duración media películas"
FROM film 
GROUP BY rating;

-- 13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name Nombre, a.last_name Apellido 
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON f.film_id = fa.film_id
WHERE title = "Indian Love";

-- 14.Muestra el título de todas las películas que contengan la cadena de caracteres "dog" o "cat" en su descripción.

SELECT title Película, description
FROM film
WHERE description REGEXP "dog|cat";   

-- 15.Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT  a.first_name Nombre, a.last_name Apellido 
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

-- 16.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title Película, release_year "Año de Estreno"
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17.Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title "Películas Categoría Family" 
FROM category c
RIGHT JOIN film_category fc
ON c.category_id = fc.category_id
RIGHT JOIN film f
ON f.film_id = fc.film_id
WHERE c.name = "Family";

-- 18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT CONCAT(a.first_name, ' ', a.last_name)  "Actor/riz (+10 películas)"
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

-- 19.Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title "Películas", rating Categoría, length Duración 
FROM film
WHERE rating = "R" AND length > (60*2)
ORDER BY length ;

-- 20.Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT rating Categoría, AVG(length) "Duración media películas"
FROM film 
GROUP BY rating
HAVING AVG(length) > 120;

-- 21.Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name Nombre, a.last_name Apellido , COUNT(fa.film_id) Películas 
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING Películas >= 5;

-- 22.Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT DISTINCT f.title Película
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id	--
    FROM inventory i
    WHERE i.inventory_id IN (
        SELECT r.inventory_id
        FROM rental r
        WHERE DATEDIFF(r.return_date, r.rental_date) > 5)
); -- resta de dos fechas de manera correcta

-- 23.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT *
    FROM film_actor fa
    INNER JOIN film_category fc
    ON fa.film_id = fc.film_id
    INNER JOIN category c       
    ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
    AND fa.actor_id = a.actor_id
);

-- 24.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT f.title  "Películas Categoría Comedia"
FROM film f
JOIN film_category fc 
ON f.film_id = fc.film_id
JOIN category c       
ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;