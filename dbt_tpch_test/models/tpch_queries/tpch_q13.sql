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
)
SELECT
    c_count,
    COUNT(*) AS custdist
FROM
    (
        SELECT
            c.customer_key,
            COUNT(o.order_key) AS c_count
        FROM
            c
            LEFT OUTER JOIN o ON c.customer_key = o.customer_key
            AND o.comment NOT LIKE '%special%requests%'
        GROUP BY
            c.customer_key
    ) c_orders
GROUP BY
    c_count
ORDER BY
    custdist desc,
    c_count desc;