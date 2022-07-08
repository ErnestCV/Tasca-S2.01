SELECT SUM(c.quantitat_begudes)
FROM comanda c
JOIN empleat e
ON c.empleat_id = e.id_empleat
JOIN botiga b
ON b.id_botiga = e.botiga_id AND b.localitat_id = 1;