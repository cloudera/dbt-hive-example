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
),
s AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_supplier") }}
),
n AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_nation") }}
),
r AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_region") }}
)
SELECT
    n.nation_name,
    SUM(extended_price * (1 - discount_percentage)) AS revenue
FROM
    c,
    o,
    l,
    s,
    n,
    r
WHERE
    c.customer_key = o.customer_key
    AND l.order_key = o.order_key
    AND l.supplier_key = s.supplier_key
    AND c.nation_key = s.nation_key
    AND s.nation_key = n.nation_key
    AND n.region_key = r.region_key
    AND region_name = 'ASIA'
    AND order_date >= '1994-01-01'
    AND CAST(order_date AS DATE) < DATE '1994-01-01' + INTERVAL '1' YEAR
GROUP BY
    n.nation_name
ORDER BY
    revenue desc