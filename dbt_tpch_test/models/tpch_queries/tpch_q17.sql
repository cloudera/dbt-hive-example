WITH l AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
),
p AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_part") }}
)
SELECT
    Round(SUM(l.extended_price) / 7.0, 3) AS avg_yearly
FROM
    l,
    p
WHERE
    p.part_key = l.part_key
    AND p.part_brand = 'Brand#23'
    AND p.part_container = 'MED BOX'
    AND l.quantity < (
        SELECT
            0.2 * AVG(l.quantity)
        FROM
            l
        WHERE
            l.part_key = p.part_key
    );