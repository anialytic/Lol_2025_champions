SELECT *
FROM champs

-- скільки персонажів кожного класу ()
-- TODO: написати код через count
SELECT herotype
	, COUNT(herotype) AS heros_count
FROM champs
GROUP BY herotype
ORDER BY heros_count DESC
-- скільки персонажів кожного класу різної складності
-- TODO: покращити запит
SELECT herotype
	, COUNT(herotype) AS heros_count
	, difficulty
FROM champs
GROUP BY herotype, difficulty
ORDER BY herotype DESC 

/*
Найменша складність, але найбільш виражений та специфічний стиль (їх 9), чому?
1) 1 танк (ближній), 4 маги, 4 сапортери (дальні)
2) високий дамаг та бафи, низька живучість та мобільність
*/
SELECT name
	, difficulty
	, herotype
	, alttype
	, rangetype
	, role
	, damage
	, toughness
	, control
	, mobility
	, utility
	, style
FROM champs
WHERE difficulty = 1 AND style = 100

--Найнижча складність, універсальні
SELECT name
	, difficulty
	, herotype
	, alttype
	, rangetype
	, role
	, damage
	, toughness
	, control
	, mobility
	, utility
	, style
FROM champs
WHERE difficulty = 1 AND style <=20

-- Скільки персонажів універсальних та спеціалізованих? 
-- TODO: переписати, розділити стиль на 3-4 категорії
SELECT style
	, COUNT(style) AS style_nmb
FROM champs
GROUP BY style
ORDER BY style 
	
--З чим пов'язаний низький дамаг? (вузькоспеціалізовані танки)
SELECT 
    name,
    difficulty,
    herotype,
    alttype,
    damage,
    style
FROM champs
WHERE damage = 1 
GROUP BY name, difficulty, herotype, alttype, damage, style

/*
Найвища складність, але універсальні
1) 2 снайпери, 1 саппорт
2) дальний бій
3) однакова ціна
4) коли реліз?
5) показники +- однакові
*/
SELECT name
	, difficulty
	, herotype
	, alttype
	, rangetype
	, role
	, damage
	, toughness
	, control
	, mobility
	, utility
	, style
	, be
	, rp
FROM champs
WHERE difficulty = 3 AND style = 10

-- Висока складність, унікальний стиль
-- 6 з них маги, високий дамаг/контроль, низька живучість, міддл
SELECT name
	, difficulty
	, herotype
	, alttype
	, rangetype
	, role
	, damage
	, toughness
	, control
	, mobility
	, utility
	, style
FROM champs
WHERE difficulty = 3 AND style >= 80

/* Чому у деяких є альттайп? Від чого це залежить? Де їх краще поставити?
1) 28 результатів. Тобто, більшість адаптивні?
2) складність 2-3 (Кейтлін 1)
3) високий дамаг
4) створити віконну функцію, щоб поразувати, скільки кожного типу? Чи є простіший спосіб?
*/
SELECT name, difficulty, herotype, alttype, rangetype, date, client_positions, external_positions, damage, toughness, control, mobility, utility, style
	,COUNT (herotype) AS type_amount
FROM champs
WHERE alttype is NULL AND 
GROUP BY 

/*
Чому у деяких є нікнейм?
14 персонажів з нікнеймами, чому?
*/
SELECT *
FROM champs
WHERE nickname IS NOT NULL

/*
Хто найдорожчий? Чи впливає це на стати? Чому на них така ціна? Яка вигода для компанії?
1) 4 найдорожчі випущені в 2024-2025
2) складність 2
3) 1 маг, 1 сапорт, 3 асасіни
4) високий дамаг
Хто найдешевший?
1) низька складність
2) 3 маги (всі мають унікальний стиль), 1 файтер, 1 асасін
3) випуск 2009 (3), 2012(1), 2019(1)
4)
*/
SELECT 
    name,
    be,
    ROUND(AVG(SUM(be)) OVER ()) AS avg_be,
    MIN(SUM(be)) OVER () AS min_be,
    MAX(SUM(be)) OVER () AS max_be,
	rp,
    ROUND(AVG(SUM(rp)) OVER ()) AS avg_rp,
    MIN(SUM(rp)) OVER () AS min_rp,
    MAX(SUM(rp)) OVER () AS max_rp
FROM champs
GROUP BY name, be, rp

-- Топ 5 найдорожчих
SELECT 
    name,
	rp,
    ROUND(AVG(SUM(rp)) OVER ()) AS avg_rp,
    MAX(SUM(rp)) OVER () AS max_rp,
	difficulty,
	alttype,
	date,
	damage,
	toughness,
	control,
	mobility,
	utility,
	style
FROM champs
GROUP BY name, rp, difficulty,
	alttype,
	date,
	damage,
	toughness,
	control,
	mobility,
	utility,
	style
ORDER BY rp DESC
LIMIT 5

-- Хто найдешевший?
SELECT 
    name,
	rp,
    ROUND(AVG(SUM(rp)) OVER ()) AS avg_rp,
    MIN(SUM(rp)) OVER () AS min_rp,
	difficulty,
	alttype,
	date,
	damage,
	toughness,
	control,
	mobility,
	utility,
	style
FROM champs
GROUP BY name, rp, difficulty,
	alttype,
	date,
	damage,
	toughness,
	control,
	mobility,
	utility,
	style
ORDER BY rp 
LIMIT 5

-- нові персонажі найдорожчі
SELECT name
	, date
	, difficulty
	, herotype
	, be
	, rp
FROM champs
WHERE date > '2023-12-31'

-- найстарші персонажі (нескладні, дешеві, багато магів)
SELECT name
	, date
	, difficulty
	, herotype
	, be
	, rp
FROM champs
ORDER BY date ASC
LIMIT 20

-- вчусь вкладеним запитам
-- герої з найвищим показником дамагу
SELECT AVG(difficulty) AS AVG_difficulty
FROM champs

SELECT name
	, MAX(difficulty)
FROM champs 
GROUP BY 1
HAVING MAX(difficulty) >
	(SELECT AVG(difficulty) AS avg_difficulty
FROM champs)
-- ще один варіант?
SELECT name, damage
FROM champs
WHERE damage = (
  SELECT MAX(damage)
  FROM champs
);

-- найвищий дамаг у класі
SELECT herotype
	, MAX(damage)
FROM champs
GROUP BY 1

SELECT name, herotype, damage
FROM champs
WHERE damage = (
  SELECT MAX(damage)
  FROM champs
);

--тренуюсь у віконних функціях
--найскладніші герої у кожній ролі
SELECT name
	, role
	, difficulty
    , DENSE_RANK() OVER (PARTITION BY role ORDER BY difficulty DESC) AS role_lvl
FROM champs

--середній показник шкоди по типу атаки
/*SELECT rangetype
	, AVG(damage) AS avg_damage
FROM champs
GROUP BY rangetype
*/
SELECT name
	, rangetype
	, AVG(damage) OVER (partition by rangetype)
	, damage - AVG(damage) OVER (partition by rangetype) AS damage_diff
FROM champs

-- мобільність у кожному типі героя
SELECT name
	, mobility
	, herotype
	, MAX(mobility) OVER (partition by herotype)
	, DENSE_RANK() OVER (PARTITION BY herotype ORDER BY mobility DESC)
FROM champs

WITH cte AS (
	SELECT name
		, mobility
		, herotype
		, MAX(mobility) OVER (partition by herotype)
		, DENSE_RANK() OVER (PARTITION BY herotype ORDER BY mobility DESC) AS dr
	FROM champs
)
SELECT *
FROM cte
WHERE dr <= 3

-- кумулятивна сума вартості
SELECT name
	, rp
	, SUM(rp) OVER (ORDER BY name ASC) AS total
FROM champs

-- дістати stats через JSON 
-- TODO: виправити лапки у stats (виконано)
/*(більше не працюватиме)SELECT id,
	name,
	(REPLACE(stats, '''', '"')::jsonb)->>'hp_base' AS hp_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'hp_lvl' AS hp_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'mp_base' AS mp_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'mp_lvl' AS mp_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'arm_base' AS arm_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'arm_lvl' AS arm_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'mr_base' AS mr_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'mr_lvl' AS mr_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'hp5_base' AS hp5_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'hp5_lvl' AS hp5_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'mp5_base' AS mp5_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'mp5_lvl' AS mp5_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'dam_base' AS dam_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'dam_lvl' AS dam_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'as_base' AS as_base,
	(REPLACE(stats, '''', '"')::jsonb)->>'as_lvl' AS as_lvl,
	(REPLACE(stats, '''', '"')::jsonb)->>'range' AS range,
	(REPLACE(stats, '''', '"')::jsonb)->>'ms' AS ms,
	(REPLACE(stats, '''', '"')::jsonb)->>'acquisition_radius' AS acquisition_radius,
	(REPLACE(stats, '''', '"')::jsonb)->>'selection_height' AS selection_height,
	(REPLACE(stats, '''', '"')::jsonb)->>'selection_radius' AS selection_radius,
	(REPLACE(stats, '''', '"')::jsonb)->>'pathing_radius' AS pathing_radius,
	(REPLACE(stats, '''', '"')::jsonb)->>'as_ratio' AS as_ratio,
	(REPLACE(stats, '''', '"')::jsonb)->>'attack_cast_time' AS attack_cast_time,
	(REPLACE(stats, '''', '"')::jsonb)->>'attack_total_time' AS attack_total_time, 
	(REPLACE(stats, '''', '"')::jsonb)->'aram'->>'dmg_dealt' AS aram_dmg_dealt,
    (REPLACE(stats, '''', '"')::jsonb)->'aram'->>'dmg_taken' AS aram_dmg_taken,
    (REPLACE(stats, '''', '"')::jsonb)->'urf'->>'dmg_dealt' AS urf_dmg_dealt,
    (REPLACE(stats, '''', '"')::jsonb)->'urf'->>'dmg_taken' AS urf_dmg_taken
FROM champs;*/

SELECT id, COUNT(*) 
FROM champs
GROUP BY id
HAVING COUNT(*) > 1;

SELECT * FROM champ_stats LIMIT 10;
SELECT * FROM champ_mods  LIMIT 10;

-- найживучіші персонажі
SELECT name, id, herotype,
	hp_lvl + hp_base AS hp
FROM champ_stats s
JOIN champs c ON s.champ_id = c.id
ORDER BY hp DESC
LIMIT 10

-- зв'язок між атк-спід з типом героя
SELECT herotype, AVG(as_ratio) AS avg_as_ratio, COUNT(*) AS hero_count
FROM champ_stats s
JOIN champs c ON s.champ_id = c.id
GROUP BY herotype
ORDER BY avg_as_ratio DESC

-- швидкість атаки/сила атаки -> мода: файтер
SELECT name, champ_id, herotype, as_ratio, dam_base + 17 * dam_lvl AS damage_lvl18
FROM champ_stats s
JOIN champs c ON s.champ_id = c.id
WHERE as_ratio > 
(
	SELECT AVG(as_ratio) AS avg_as_ratio
	FROM champ_stats
) AND (dam_base + 17*dam_lvl) > (SELECT AVG(dam_base + 17*dam_lvl) FROM champ_stats)
ORDER BY as_ratio DESC