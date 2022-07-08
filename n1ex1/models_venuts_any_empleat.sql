SELECT v.ulleres_id, m.nom, v.data_venda, v.empleat
FROM optica.venda v
JOIN optica.ulleres u
ON u.id_ulleres = v.ulleres_id AND v.empleat = 'Ernest' AND v.data_venda >= '2022-01-01' AND v.data_venda <= '2022-12-31'
JOIN optica.marca m
ON u.marca_id = m.id_marca;
