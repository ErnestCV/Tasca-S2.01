SELECT 
	COUNT(p.id_producte) AS 'Nombre pizzes'
FROM
	producte p
JOIN 
	comandes_productes cp 
ON 
	cp.producte_id = p.id_producte
JOIN
	comanda c
ON
	c.id_comanda = cp.comanda_id
WHERE 
	c.id_comanda = 1 AND p.tipus = 'pizza';