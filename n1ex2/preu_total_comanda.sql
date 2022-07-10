SELECT 
	SUM(p.preu) AS 'Preu total'
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
	c.id_comanda = 1;