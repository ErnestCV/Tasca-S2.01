SELECT v.ulleres_id AS 'id ullera venuda', p.nom AS 'nom proveidor'
FROM optica.venda v
JOIN optica.ulleres u
ON v.ulleres_id = u.id_ulleres
JOIN optica.marca m
ON u.marca_id = m.id_marca
JOIN optica.proveidor p
ON m.proveidor_id = p.id_proveidor;