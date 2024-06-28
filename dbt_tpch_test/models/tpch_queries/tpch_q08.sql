SELECT
    o_year,
    ROUND(SUM(
        CASE
            WHEN nation = 'BRAZIL' THEN volume
            ELSE 0
        END
    ) / SUM(volume), 3) AS mkt_share
FROM
    (
        SELECT
            EXTRACT(
                YEAR
                FROM
                    CAST(o.order_date AS DATE)
            ) AS o_year,
            ROUND(l.extended_price * (1 - l.discount_percentage), 3) AS volume,
            n2.nation_name AS nation
        FROM
            {{ ref("stg_tpch_part") }} p,
            {{ ref("stg_tpch_supplier") }} s,
            {{ ref("stg_tpch_lineitem") }} l,
            {{ ref("stg_tpch_orders") }} o,
            {{ ref("stg_tpch_customer") }} c,
            {{ ref("stg_tpch_nation") }} n1,
            {{ ref("stg_tpch_nation") }} n2,
            {{ ref("stg_tpch_region") }} r
        WHERE
            p.part_key = l.part_key
            AND s.supplier_key = l.supplier_key
            AND l.order_key = o.order_key
            AND o.customer_key = c.customer_key
            AND c.nation_key = n1.nation_key
            AND n1.region_key = r.region_key
            AND r.region_name = 'AMERICA'
            AND s.nation_key = n2.nation_key
            AND CAST(o.order_date AS DATE) BETWEEN DATE '1995-01-01'
            AND DATE '1996-12-31'
            AND p.part_type = 'ECONOMY ANODIZED STEEL'
    ) AS all_nations
GROUP BY
    o_year
ORDER BY
    o_year;