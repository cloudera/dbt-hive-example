WITH revenue_cached AS(
    SELECT
        l.supplier_key AS supplier_no,
        SUM(l.extended_price * (1 - l.discount_percentage)) AS total_revenue
    FROM
        {{ ref("stg_tpch_lineitem") }} l
    WHERE
        l.ship_date >= '1996-01-01'
        and l.ship_date < '1996-04-01'
    GROUP BY
        l.supplier_key
),
max_revenue_cached AS(
    SELECT
        MAX(total_revenue) AS max_revenue
    FROM
        revenue_cached
)
SELECT
    s.supplier_key,
    s.supplier_name,
    s.supplier_address,
    s.phone_number,
    r.total_revenue
FROM
    {{ ref("stg_tpch_supplier") }} s,
    revenue_cached r,
    max_revenue_cached
WHERE
    s.supplier_key = r.supplier_no
    AND total_revenue = max_revenue
ORDER BY
    s.supplier_key;