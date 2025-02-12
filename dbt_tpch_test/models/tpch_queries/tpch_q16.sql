WITH ps AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_partsupp") }}
),
p AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_part") }}
),
s AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_supplier") }}
)
SELECT
    p.part_brand,
    p.part_type,
    p.part_size,
    COUNT(DISTINCT ps.supplier_key) AS supplier_cnt
FROM
    ps,
    p
WHERE
    p.part_key = ps.part_key
    AND p.part_brand <> 'Brand#45'
    AND p.part_type NOT LIKE 'MEDIUM POLISHED%'
    AND p.part_size IN (49, 14, 23, 45, 19, 3, 36, 9)
    AND ps.supplier_key NOT IN (
        SELECT
            s.supplier_key
        FROM
            s
        WHERE
            s.comment LIKE '%Customer%Complaints%'
    )
GROUP BY
    p.part_brand,
    p.part_type,
    p.part_size
ORDER BY
    supplier_cnt DESC,
    p.part_brand,
    p.part_type,
    p.part_size;