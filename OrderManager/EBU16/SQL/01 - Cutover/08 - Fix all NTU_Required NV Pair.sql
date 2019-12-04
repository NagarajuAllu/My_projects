SELECT name, count(*)
  FROM stc_name_value
 WHERE name LIKE 'NTU%Required'
GROUP BY name;

UPDATE stc_name_value 
   SET name = 'NTURequired' 
 WHERE name LIKE 'NTU Required';