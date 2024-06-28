WITH ps AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_partsupp") }}
),
n AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_nation") }}
),
s AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_supplier") }}
),
p AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_part") }}
),
l AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
)
SELECT
    s.supplier_name,
    s.supplier_address
FROM
    s,
    n
WHERE
    s.supplier_key IN (
        SELECT
            ps.supplier_key
        FROM
            ps
        WHERE
            ps.part_key IN (
                SELECT
                    p.part_key
                FROM
                    p
                WHERE
                    p.part_name LIKE 'forest%'
            )
            AND ps.available_quantity > (
                SELECT
                    0.5 * SUM(l.quantity)
                FROM
                    l
                WHERE
                    l.part_key = ps.part_key
                    AND l.supplier_key = ps.supplier_key
                    AND l.ship_date >= '1994-01-01'
                    AND CAST(l.ship_date AS DATE) < DATE('1994-01-01') + INTERVAL '1' YEAR
            )
    )
    AND s.nation_key = n.nation_key
    AND n.nation_name = 'CANADA'
ORDER BY
    s.supplier_name;