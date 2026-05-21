INSERT INTO tz_regions (region_id, region_name, zone, climate_type)
SELECT CAST('9b66f595-23bc-4bc2-a2a4-9041d6542b40' AS UUID), 'Dar es Salaam', 'Coastal', 'Tropical'
WHERE NOT EXISTS (
    SELECT 1 FROM tz_regions WHERE region_name = 'Dar es Salaam'
);

INSERT INTO tz_regions (region_id, region_name, zone, climate_type)
SELECT CAST('55f0476f-f7f3-49ba-a771-9705daf05841' AS UUID), 'Arusha', 'Northern Highlands', 'Temperate Highland'
WHERE NOT EXISTS (
    SELECT 1 FROM tz_regions WHERE region_name = 'Arusha'
);

INSERT INTO tz_regions (region_id, region_name, zone, climate_type)
SELECT CAST('39564644-9ba4-4baa-a042-c8bcbe2a2373' AS UUID), 'Mwanza', 'Lake Zone', 'Tropical Savanna'
WHERE NOT EXISTS (
    SELECT 1 FROM tz_regions WHERE region_name = 'Mwanza'
);

INSERT INTO nutrition_categories (category_id, category_name, description)
SELECT CAST('7a862237-b350-4f89-b0cf-e2f45184f4f9' AS UUID), 'Maternal Nutrition', 'Guidance for pregnancy and postnatal nutrition care.'
WHERE NOT EXISTS (
    SELECT 1 FROM nutrition_categories WHERE category_name = 'Maternal Nutrition'
);

INSERT INTO nutrition_categories (category_id, category_name, description)
SELECT CAST('3fc9e131-a4b7-4d4a-8ece-552f0d862ee1' AS UUID), 'Child Nutrition', 'Infant and child feeding best practices according to TFNC guidance.'
WHERE NOT EXISTS (
    SELECT 1 FROM nutrition_categories WHERE category_name = 'Child Nutrition'
);

INSERT INTO nutrition_categories (category_id, category_name, description)
SELECT CAST('289f2140-51c4-489f-9a56-40e4f7489c06' AS UUID), 'General Healthy Eating', 'Everyday balanced diet recommendations for adults.'
WHERE NOT EXISTS (
    SELECT 1 FROM nutrition_categories WHERE category_name = 'General Healthy Eating'
);
