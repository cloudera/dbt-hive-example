SELECT
    nation,
    o_year,
    SUM(amount) AS sum_profit
FROM
    (
        SELECT
            n.nation_name AS nation,
            year(o.order_date) as o_year,
            l.extended_price * (1 - l.discount_percentage) - ps.cost * l.quantity AS amount
        FROM
            {{ ref("stg_tpch_part") }} p,
            {{ ref("stg_tpch_supplier") }} s,
            {{ ref("stg_tpch_lineitem") }} l,
            {{ ref("stg_tpch_partsupp") }} ps,
            {{ ref("stg_tpch_orders") }} o,
            {{ ref("stg_tpch_nation") }} n
        WHERE
            s.supplier_key = l.supplier_key
            AND ps.supplier_key = l.supplier_key
            AND ps.part_key = l.part_key
            AND p.part_key = l.part_key
            AND o.order_key = l.order_key
            AND s.nation_key = n.nation_key
            AND p.part_name LIKE '%green%'
    ) AS profit
GROUP BY
    nation,
    o_year
ORDER BY
    nation,
    o_year DESC;