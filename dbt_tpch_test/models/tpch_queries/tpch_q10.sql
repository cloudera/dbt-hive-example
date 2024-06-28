SELECT
    c.customer_key,
    c.name,
    SUM(l.extended_price * (1 - l.discount_percentage)) AS revenue,
    c.account_balance,
    n.nation_name,
    c.address,
    c.phone_number,
    c.comment
FROM
    {{ ref("stg_tpch_customer") }} c,
    {{ ref("stg_tpch_orders") }} o,
    {{ ref("stg_tpch_lineitem") }} l,
    {{ ref("stg_tpch_nation") }} n
WHERE
    c.customer_key = o.customer_key
    AND l.order_key = o.order_key
    AND o.order_date >= '1993-10-01'
    and o.order_date < date '1994-01-01'
    AND l.return_flag = 'R'
    AND c.nation_key = n.nation_key
GROUP BY
    c.customer_key,
    c.name,
    c.account_balance,
    c.phone_number,
    n.nation_name,
    c.address,
    c.comment
ORDER BY
    revenue DESC
LIMIT 20;