SELECT COUNT(p.id_producte)
FROM producte p
JOIN comandes_productes cp
ON cp.producte_id = p.id_producte
JOIN comanda c
ON c.id_comanda = cp.comanda_id
JOIN botiga b
ON c.botiga_id = b.id_botiga
WHERE p.tipus = 'Beguda' AND b.localitat_id = 1;