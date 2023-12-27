/*
	Без повторение заглавията и годините на всички филми, заснети преди 1982, в които е играл поне един актьор
	(актриса), чието име не съдържа нито буквата 'k', нито 'b'. Първо да се изведат най-старите филми.
*/

SELECT 
	title,
	year
FROM MOVIE
WHERE 
	year < 1982 AND 
	(
	SELECT	
		COUNT(*)
	FROM MOVIE M1
	JOIN STARSIN ON
		M1.TITLE = STARSIN.MOVIETITLE
	WHERE 
		M1.TITLE = MOVIE.TITLE AND 
		STARNAME NOT LIKE '%k%' AND 
		STARNAME NOT LIKE '%b%'
	) > 0
ORDER BY year;

/*
	Заглавията и дължините в часове (length е в минути) на всички филми, които са от същата година, от която е и филмът
	Terms of Endearment, но дължината им е по-малка или неизвестна.
*/



SELECT 
	TITLE,
	LENGTH * 1.0 / 60 AS "Length in Hours"
FROM MOVIE
WHERE 
	YEAR = (
	SELECT 
		year 
	FROM MOVIE
	WHERE title = 'Terms of Endearment'
	) AND (LENGTH < (
	SELECT 
		length
	FROM MOVIE
	WHERE title = 'Terms of Endearment'
	) OR LENGTH IS NULL
);

/*
	Имената на всички продуценти, които са и филмови звезди и са играли в поне един филм преди 1980 г. и поне един
	след 1985 г.
*/

SELECT 
	DISTINCT MOVIESTAR.NAME
FROM MOVIESTAR
LEFT JOIN STARSIN ON
	MOVIESTAR.NAME = STARSIN.STARNAME
WHERE 
	 NAME IN (
		SELECT NAME FROM MOVIEEXEC)
	AND (
		SELECT 
			COUNT(*)
		FROM STARSIN S1
		JOIN MOVIE ON
			S1.MOVIETITLE = MOVIE.TITLE
		WHERE 
			S1.STARNAME = STARSIN.STARNAME AND 
			YEAR > 1985
	) > 0 AND (
		SELECT 
			COUNT(*)
		FROM STARSIN S2
		JOIN MOVIE ON
			S2.MOVIETITLE = MOVIE.TITLE
		WHERE 
			S2.STARNAME = STARSIN.STARNAME AND 
			YEAR < 1980
	) > 0;

/*
	Всички черно-бели филми, записани преди най-стария цветен филм (InColor='y'/'n') на същото студио.
*/

SELECT 
	* 
FROM MOVIE
WHERE 
	INCOLOR = 'N' AND 
	YEAR < (
	SELECT TOP 1
	YEAR
FROM MOVIE 
JOIN STUDIO S1 ON
	S1.NAME = MOVIE.STUDIONAME
WHERE 
	S1.NAME = (SELECT STUDIONAME FROM MOVIE WHERE INCOLOR = 'N') AND 
	INCOLOR = 'Y'
ORDER BY YEAR);
 
/*
	Имената и адресите на студиата, които са работили с по-малко от 5 различни филмови звезди. Студиа, за които няма
	посочени филми или има, но не се знае кои актьори са играли в тях, също да бъдат изведени. Първо да се изведат
	студиата, работили с най-много звезди. Напр. ако студиото има два филма, като в първия са играли A, B и C, а във
	втория - C, D и Е, то студиото е работило с 5 звезди общо
*/

SELECT 
	NAME,
	ADDRESS
FROM STUDIO
WHERE(
		SELECT SUM(actor_movie_count) FROM (
		SELECT 
			COUNT(STARNAME) AS actor_movie_count
		FROM STUDIO S1
		JOIN MOVIE ON 
			S1.NAME = MOVIE.STUDIONAME
		JOIN STARSIN ON
			STARSIN.MOVIETITLE = MOVIE.TITLE
		WHERE 
			S1.NAME = STUDIO.NAME
		GROUP BY STARNAME) AS subquery
	) < 5 OR NAME IN (
		SELECT 
			NAME
		FROM STUDIO
		LEFT JOIN MOVIE ON 
			STUDIO.NAME = MOVIE.STUDIONAME
		WHERE MOVIE.TITLE IS NULL
	) OR NAME IN (
	SELECT 
		NAME 
	FROM STUDIO
	JOIN MOVIE ON 
		STUDIO.NAME = MOVIE.STUDIONAME
	LEFT JOIN STARSIN ON
		MOVIE.TITLE = STARSIN.MOVIETITLE
	WHERE MOVIETITLE IS NULL
	)
ORDER BY (
	SELECT SUM(actor_movie_count) FROM (
	SELECT 
		COUNT(STARNAME) AS actor_movie_count
	FROM STUDIO S1
	JOIN MOVIE ON 
		S1.NAME = MOVIE.STUDIONAME
	JOIN STARSIN ON
		STARSIN.MOVIETITLE = MOVIE.TITLE
	WHERE 
		S1.NAME = STUDIO.NAME
	GROUP BY STARNAME) AS subquery
) DESC;
