WITH s AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_supplier") }}
),
l1 AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
),
o AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_orders") }}
),
n AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_nation") }}
),
l2 AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
),
l3 AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
)
SELECT
    s.supplier_name,
    COUNT(*) AS numwait
FROM
    s,
    l1,
    o,
    n
WHERE
    s.supplier_key = l1.supplier_key
    AND o.order_key = l1.order_key
    AND o.status_code = 'F'
    AND l1.receipt_date > l1.commit_date
    AND EXISTS (
        SELECT
            *
        FROM
            l2
        WHERE
            l2.order_key = l1.order_key
            AND l2.supplier_key <> l1.supplier_key
    )
    AND NOT EXISTS (
        SELECT
            *
        FROM
            l3
        WHERE
            l3.order_key = l1.order_key
            AND l3.supplier_key <> l1.supplier_key
            AND l3.receipt_date > l3.commit_date
    )
    AND s.nation_key = n.nation_key
    AND n.nation_name = 'SAUDI ARABIA'
GROUP BY
    s.supplier_name
ORDER BY
    numwait DESC,
    s.supplier_name
limit 100;