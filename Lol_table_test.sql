SELECT *
FROM champs

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
	, be
	, rp
FROM champs
WHERE difficulty = 1 AND style = 100

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