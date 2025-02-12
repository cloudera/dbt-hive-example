WITH o AS (
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
    l.ship_mode,
    SUM(
        CASE
            WHEN o.priority_code = '1-URGENT'
            OR o.priority_code = '2-HIGH' THEN 1
            ELSE 0
        END
    ) AS high_line_count,
    SUM(
        CASE
            WHEN o.priority_code <> '1-URGENT'
            AND o.priority_code <> '2-HIGH' THEN 1
            ELSE 0
        END
    ) AS low_line_count
FROM
    o,
    l
WHERE
    o.order_key = l.order_key
    AND l.ship_mode IN ('MAIL', 'SHIP')
    AND l.commit_date < l.receipt_date
    AND l.ship_date < l.commit_date
    AND l.receipt_date >= '1994-01-01'
    AND CAST(l.receipt_date AS DATE) < DATE '1994-01-01' + INTERVAL '1' YEAR
GROUP BY
    l.ship_mode
ORDER BY
    l.ship_mode;