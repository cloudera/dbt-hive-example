SELECT
    supp_nation,
    cust_nation,
    l_year,
    SUM(volume) AS revenue
FROM
    (
        SELECT
            n1.nation_name AS supp_nation,
            n2.nation_name AS cust_nation,
            EXTRACT(
                YEAR
                FROM
                    CAST(l.ship_date AS DATE)
            ) AS l_year,
            l.extended_price * (1 - l.discount_percentage) AS volume
        FROM
            {{ ref("stg_tpch_supplier") }} s,
            {{ ref("stg_tpch_lineitem") }} l,
            {{ ref("stg_tpch_orders") }} o,
            {{ ref("stg_tpch_customer") }} c,
            {{ ref("stg_tpch_nation") }} n1,
            {{ ref("stg_tpch_nation") }} n2
        WHERE
            s.supplier_key = l.supplier_key
            AND o.order_key = l.order_key
            AND c.customer_key = o.customer_key
            AND s.nation_key = n1.nation_key
            AND c.nation_key = n2.nation_key
            AND (
                (
                    n1.nation_name = 'FRANCE'
                    AND n2.nation_name = 'GERMANY'
                )
                OR (
                    n1.nation_name = 'GERMANY'
                    AND n2.nation_name = 'FRANCE'
                )
            )
            AND CAST(l.ship_date AS DATE) BETWEEN DATE '1995-01-01'
            AND DATE '1996-12-31'
    ) AS shipping
GROUP BY
    supp_nation,
    cust_nation,
    l_year
ORDER BY
    supp_nation,
    cust_nation,
    l_year;