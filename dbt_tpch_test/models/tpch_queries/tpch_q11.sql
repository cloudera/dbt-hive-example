WITH 
ps AS (
    SELECT *
    FROM {{ ref("stg_tpch_partsupp") }}
),
s AS (
    SELECT *
    FROM {{ ref("stg_tpch_supplier") }}
),
n AS (
    SELECT *
    FROM {{ ref("stg_tpch_nation") }}
),
q11_part_tmp_cached AS (
    SELECT
        part_key,
        SUM(ps.cost * ps.available_quantity) AS part_value
    FROM
        ps
        JOIN s ON ps.supplier_key = s.supplier_key
        JOIN n ON s.nation_key = n.nation_key
    WHERE
        n.nation_name = 'GERMANY'
    GROUP BY
        part_key
),    
q11_sum_tmp_cached AS (
    SELECT
        SUM(part_value) AS total_value
    FROM
        q11_part_tmp_cached
)   
SELECT
    part_key,
    part_value AS value
FROM
    (
        SELECT
            part_key,
            part_value,
            total_value
        FROM
            q11_part_tmp_cached
            JOIN q11_sum_tmp_cached
    ) a
WHERE
    part_value > total_value * 0.0001
ORDER BY
    value DESC;
