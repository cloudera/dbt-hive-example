WITH c AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_customer") }}
),
o AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_orders") }}
),
l AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
)
SELECT
    c.name,
    c.customer_key,
    o.order_key,
    o.order_date,
    o.total_price,
    SUM(l.quantity) as total_quantity
FROM
    c,
    o,
    l
WHERE
    o.order_key IN (
        SELECT
            l.order_key
        FROM
            l
        GROUP BY
            l.order_key
        HAVING
            SUM(l.quantity) > 300
    )
    AND c.customer_key = o.customer_key
    AND o.order_key = l.order_key
GROUP BY
    c.name,
    c.customer_key,
    o.order_key,
    o.order_date,
    o.total_price
ORDER BY
    o.total_price DESC,
    o.order_date
limit 100;