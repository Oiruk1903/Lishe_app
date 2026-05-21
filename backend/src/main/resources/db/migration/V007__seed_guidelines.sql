INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d001' AS UUID), 'KCAL', 'PREGNANT', 2200, 2200, 'kcal', 'TFNC-based pregnancy energy target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'KCAL' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d002' AS UUID), 'PROTEIN', 'PREGNANT', 71, 71, 'g', 'TFNC-based pregnancy protein target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'PROTEIN' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d003' AS UUID), 'FAT', 'PREGNANT', 63, 63, 'g', 'TFNC-based pregnancy fat target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'FAT' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d004' AS UUID), 'CARBS', 'PREGNANT', 175, 175, 'g', 'TFNC-based pregnancy carbohydrate target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CARBS' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d005' AS UUID), 'IRON', 'PREGNANT', 27, 45, 'mg', 'TFNC-based pregnancy iron target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'IRON' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d006' AS UUID), 'CALCIUM', 'PREGNANT', 1000, 1000, 'mg', 'TFNC-based pregnancy calcium target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CALCIUM' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d007' AS UUID), 'VIT_A', 'PREGNANT', 770, 770, 'mcg', 'TFNC-based pregnancy vitamin A target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'VIT_A' AND cohort = 'PREGNANT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d101' AS UUID), 'KCAL', 'LACTATING', 2500, 2500, 'kcal', 'TFNC-based lactation energy target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'KCAL' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d102' AS UUID), 'PROTEIN', 'LACTATING', 71, 71, 'g', 'TFNC-based lactation protein target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'PROTEIN' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d103' AS UUID), 'FAT', 'LACTATING', 71, 71, 'g', 'TFNC-based lactation fat target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'FAT' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d104' AS UUID), 'CARBS', 'LACTATING', 210, 210, 'g', 'TFNC-based lactation carbohydrate target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CARBS' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d105' AS UUID), 'IRON', 'LACTATING', 9, 45, 'mg', 'TFNC-based lactation iron target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'IRON' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d106' AS UUID), 'CALCIUM', 'LACTATING', 1000, 1000, 'mg', 'TFNC-based lactation calcium target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CALCIUM' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d107' AS UUID), 'VIT_A', 'LACTATING', 1300, 1300, 'mcg', 'TFNC-based lactation vitamin A target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'VIT_A' AND cohort = 'LACTATING');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d201' AS UUID), 'KCAL', 'ADOLESCENT', 2200, 2200, 'kcal', 'TFNC-based adolescent energy target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'KCAL' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d202' AS UUID), 'PROTEIN', 'ADOLESCENT', 52, 52, 'g', 'TFNC-based adolescent protein target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'PROTEIN' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d203' AS UUID), 'FAT', 'ADOLESCENT', 70, 70, 'g', 'TFNC-based adolescent fat target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'FAT' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d204' AS UUID), 'CARBS', 'ADOLESCENT', 300, 300, 'g', 'TFNC-based adolescent carbohydrate target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CARBS' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d205' AS UUID), 'IRON', 'ADOLESCENT', 11, 45, 'mg', 'TFNC-based adolescent iron target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'IRON' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d206' AS UUID), 'CALCIUM', 'ADOLESCENT', 1300, 1300, 'mg', 'TFNC-based adolescent calcium target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CALCIUM' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d207' AS UUID), 'VIT_A', 'ADOLESCENT', 900, 900, 'mcg', 'TFNC-based adolescent vitamin A target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'VIT_A' AND cohort = 'ADOLESCENT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d301' AS UUID), 'KCAL', 'ADULT', 2200, 2200, 'kcal', 'TFNC-based adult energy target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'KCAL' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d302' AS UUID), 'PROTEIN', 'ADULT', 56, 56, 'g', 'TFNC-based adult protein target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'PROTEIN' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d303' AS UUID), 'FAT', 'ADULT', 65, 65, 'g', 'TFNC-based adult fat target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'FAT' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d304' AS UUID), 'CARBS', 'ADULT', 275, 275, 'g', 'TFNC-based adult carbohydrate target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CARBS' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d305' AS UUID), 'IRON', 'ADULT', 8, 45, 'mg', 'TFNC-based adult iron target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'IRON' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d306' AS UUID), 'CALCIUM', 'ADULT', 1000, 1000, 'mg', 'TFNC-based adult calcium target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CALCIUM' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d307' AS UUID), 'VIT_A', 'ADULT', 900, 900, 'mcg', 'TFNC-based adult vitamin A target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'VIT_A' AND cohort = 'ADULT');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d401' AS UUID), 'KCAL', 'CHILD_UNDER5', 1200, 1200, 'kcal', 'TFNC-based child under five energy target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'KCAL' AND cohort = 'CHILD_UNDER5');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d402' AS UUID), 'PROTEIN', 'CHILD_UNDER5', 13, 13, 'g', 'TFNC-based child under five protein target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'PROTEIN' AND cohort = 'CHILD_UNDER5');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d403' AS UUID), 'FAT', 'CHILD_UNDER5', 40, 40, 'g', 'TFNC-based child under five fat target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'FAT' AND cohort = 'CHILD_UNDER5');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d404' AS UUID), 'CARBS', 'CHILD_UNDER5', 130, 130, 'g', 'TFNC-based child under five carbohydrate target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CARBS' AND cohort = 'CHILD_UNDER5');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d405' AS UUID), 'IRON', 'CHILD_UNDER5', 7, 40, 'mg', 'TFNC-based child under five iron target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'IRON' AND cohort = 'CHILD_UNDER5');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d406' AS UUID), 'CALCIUM', 'CHILD_UNDER5', 700, 700, 'mg', 'TFNC-based child under five calcium target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'CALCIUM' AND cohort = 'CHILD_UNDER5');

INSERT INTO nutrition_guidelines (id, nutrient_code, cohort, min_daily, max_daily, unit, notes, created_at)
SELECT CAST('8f1d1a2a-5f52-4f2f-bb0e-5a4b35b7d407' AS UUID), 'VIT_A', 'CHILD_UNDER5', 300, 300, 'mcg', 'TFNC-based child under five vitamin A target.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM nutrition_guidelines WHERE nutrient_code = 'VIT_A' AND cohort = 'CHILD_UNDER5');