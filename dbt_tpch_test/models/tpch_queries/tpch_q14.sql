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
    ROUND(100.00 * SUM(
        CASE
            WHEN p.part_type LIKE 'PROMO%' THEN l.extended_price * (1 - l.discount_percentage)
            ELSE 0
        END
    ) / SUM(l.extended_price * (1 - l.discount_percentage)), 3) AS promo_revenue
FROM
    l,
    p
WHERE
    l.part_key = p.part_key
    AND l.ship_date >= '1995-09-01'
    AND CAST(l.ship_date AS DATE) < DATE '1995-09-01' + INTERVAL '1' MONTH;