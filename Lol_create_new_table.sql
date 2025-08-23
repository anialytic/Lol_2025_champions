-- змінити стати на тип jsonb
BEGIN;

-- замінити одинарні лапки на подвійні у всіх рядках
UPDATE champs
SET stats = REPLACE(stats, '''', '"');

-- перетворити колонку в тип jsonb
ALTER TABLE champs
ALTER COLUMN stats TYPE jsonb
USING stats::jsonb;

COMMIT;

-- зробити унікальними
ALTER TABLE champs
ADD CONSTRAINT champs_pkey PRIMARY KEY (id);

-- створити порожні таблиці
CREATE TABLE IF NOT EXISTS champ_stats (
    champ_id           TEXT PRIMARY KEY REFERENCES champs(id) ON DELETE CASCADE,
    hp_base            INT,
    hp_lvl             INT,
    mp_base            INT,
    mp_lvl             INT,
    arm_base           DOUBLE PRECISION,
    arm_lvl            DOUBLE PRECISION,
    mr_base            DOUBLE PRECISION,
    mr_lvl             DOUBLE PRECISION,
    hp5_base           DOUBLE PRECISION,
    hp5_lvl            DOUBLE PRECISION,
    mp5_base           DOUBLE PRECISION,
    mp5_lvl            DOUBLE PRECISION,
    dam_base           DOUBLE PRECISION,
    dam_lvl            DOUBLE PRECISION,
    as_base            DOUBLE PRECISION,
    as_lvl             DOUBLE PRECISION,
    atk_range          INT,
    ms                 INT,
    acquisition_radius INT,
    selection_height   INT,
    selection_radius   INT,
    pathing_radius     INT,
    as_ratio           DOUBLE PRECISION,
    attack_cast_time   DOUBLE PRECISION,
    attack_total_time  DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS champ_mods (
    champ_id  TEXT REFERENCES champs(id) ON DELETE CASCADE,
    mode      TEXT,                      -- 'aram' або 'urf'
    dmg_dealt DOUBLE PRECISION,
    dmg_taken DOUBLE PRECISION,
    PRIMARY KEY (champ_id, mode)
);

-- заповнити таблицю
TRUNCATE champ_stats;

INSERT INTO champ_stats (
    champ_id, hp_base, hp_lvl, mp_base, mp_lvl,
    arm_base, arm_lvl, mr_base, mr_lvl,
    hp5_base, hp5_lvl, mp5_base, mp5_lvl,
    dam_base, dam_lvl, as_base, as_lvl,
    atk_range, ms,
    acquisition_radius, selection_height, selection_radius, pathing_radius,
    as_ratio, attack_cast_time, attack_total_time
)
SELECT
    c.id,
    (c.stats->>'hp_base')::double precision,
    (c.stats->>'hp_lvl')::double precision,
    (c.stats->>'mp_base')::double precision,
    (c.stats->>'mp_lvl')::double precision,
    (c.stats->>'arm_base')::double precision,
    (c.stats->>'arm_lvl')::double precision,
    (c.stats->>'mr_base')::double precision,
    (c.stats->>'mr_lvl')::double precision,
    (c.stats->>'hp5_base')::double precision,
    (c.stats->>'hp5_lvl')::double precision,
    (c.stats->>'mp5_base')::double precision,
    (c.stats->>'mp5_lvl')::double precision,
    (c.stats->>'dam_base')::double precision,
    (c.stats->>'dam_lvl')::double precision,
    (c.stats->>'as_base')::double precision,
    (c.stats->>'as_lvl')::double precision,
    (c.stats->>'range')::double precision,
    (c.stats->>'ms')::double precision,
    (c.stats->>'acquisition_radius')::double precision,
    (c.stats->>'selection_height')::double precision,
    (c.stats->>'selection_radius')::double precision,
    (c.stats->>'pathing_radius')::double precision,
    (c.stats->>'as_ratio')::double precision,
    (c.stats->>'attack_cast_time')::double precision,
    (c.stats->>'attack_total_time')::double precision
FROM champs c;

TRUNCATE champ_mods;

INSERT INTO champ_mods (champ_id, mode, dmg_dealt, dmg_taken)
SELECT
    c.id,
    kv.key AS mode,
    (kv.value->>'dmg_dealt')::double precision,
    (kv.value->>'dmg_taken')::double precision
FROM champs c
CROSS JOIN LATERAL jsonb_each(
    jsonb_build_object(
        'aram', c.stats->'aram',
        'urf',  c.stats->'urf'
    )
) AS kv(key, value);