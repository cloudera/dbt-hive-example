SELECT
    SUM(extended_price * discount_percentage) AS revenue
FROM
    {{ ref("stg_tpch_lineitem") }}
WHERE
    ship_date >= '1994-01-01'
    AND CAST(ship_date AS DATE) < DATE '1994-01-01' + INTERVAL '1' YEAR
    AND discount_percentage BETWEEN 0.06 - 0.01
    AND 0.06 + 0.01
    AND quantity < 24;