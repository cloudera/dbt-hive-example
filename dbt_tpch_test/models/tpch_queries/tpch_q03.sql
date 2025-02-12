WITH c AS (
    SELECT
        *
    FROM
        {{ ref ("stg_tpch_customer") }}
),
o AS (
    SELECT
        *
    FROM
        {{ ref('stg_tpch_orders') }}
),
l AS (
    SELECT
        *
    FROM
        {{ ref('stg_tpch_lineitem') }}
)
SELECT
    l.order_key,
    SUM(extended_price * (1 - discount_percentage)) AS revenue,
    order_date,
    ship_priority
FROM
    c,
    o,
    l
WHERE
    market_segment = 'BUILDING'
    AND c.customer_key = o.customer_key
    AND l.order_key = o.order_key
    AND order_date < '1995-03-15'
    AND ship_date > '1995-03-15'
GROUP BY
    l.order_key,
    o.order_date,
    o.ship_priority
ORDER BY
    revenue DESC,
    order_date
limit 10;