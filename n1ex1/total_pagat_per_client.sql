SELECT SUM(u.preu)
FROM optica.venda v
JOIN optica.clients c
ON v.client_id = c.id_client AND c.id_client = 2
JOIN optica.ulleres u
ON v.ulleres_id = u.id_ulleres;