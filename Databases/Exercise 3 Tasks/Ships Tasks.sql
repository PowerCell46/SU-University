use ships;

select 
	COUNTRY 
From ships
JOIN classes on 
	ships.class = CLASSes.CLASS
WHERE NUMGUNS = (SELECT TOP 1 NUMGUNS FROM classes ORDER BY NUMGUNS DESC)
GROUP BY COUNTRY;


SELECT name FROM ships 
JOIN classes ON
	ships.CLASS = CLASSES.CLASS
WHERE BORE = 16;


SELECT BATTLE 
FROM OUTCOMES
WHERE ship in (
SELECT ships.NAME FROM CLASSES
JOIN ships ON ships.CLASS = CLASSES.CLASS
WHERE classes.class = 'Kongo'
);


SELECT 
	bore, 
	MAX(NUMGUNS) AS numguns 
FROM SHIPS 
JOIN CLASSES ON 
	CLASSES.CLASS = ships.CLASS
GROUP BY BORE
ORDER BY BORE DESC;


/*
SELECT * FROM CLASSES
JOIN SHIPS ON CLASSES.CLASS = SHIPS.CLASS
WHERE BORE IN 
(
	SELECT 
		bore
	FROM SHIPS 
	JOIN CLASSES ON 
		CLASSES.CLASS = ships.CLASS
	GROUP BY BORE
)
AND NUMGUNS IN (
	SELECT 
		MAX(NUMGUNS)
	FROM SHIPS 
	JOIN CLASSES ON 
		CLASSES.CLASS = ships.CLASS
	GROUP BY BORE
);
*/
