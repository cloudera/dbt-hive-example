WITH o AS (
    SELECT
        *
    FROM
        {{ ref ("stg_tpch_orders") }}
),
l AS (
    SELECT
        *
    FROM
        {{ ref('stg_tpch_lineitem') }}
)
SELECT
    o.priority_code,
    COUNT(*) AS order_count
FROM
    o
WHERE
    o.order_date >= '1993-07-01'
    AND o.order_date < date '1993-10-01'
    AND EXISTS (
        SELECT
            *
        FROM
            l
        WHERE
            l.order_key = o.order_key
            AND l.commit_date < l.receipt_date
    )
GROUP BY
    o.priority_code
ORDER BY
    o.priority_code;