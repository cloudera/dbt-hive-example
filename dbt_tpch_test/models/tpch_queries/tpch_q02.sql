WITH p0 AS (
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
),
ps AS (
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
r AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_region") }}
)
SELECT
    s.account_balance,
    s.supplier_name,
    n.nation_name,
    p0.part_key,
    p0.manufacturer_name,
    s.supplier_address,
    s.phone_number,
    s.comment
FROM
    p0,
    s,
    ps,
    n,
    r,
    (
                select
                        p0.part_key,
                        min(ps.cost) as minsupplycost
                FROM
                        p0,
                        ps,
                        s,
                        n,
                        r
                WHERE
                        p0.part_key = ps.part_key
                        AND s.supplier_key = ps.supplier_key
                        AND s.nation_key = n.nation_key
                        AND n.region_key = r.region_key
                        AND r.region_name = 'EUROPE'
                group by
                        p0.part_key) p
WHERE
    p0.part_key = ps.part_key
    AND s.supplier_key = ps.supplier_key
    AND p0.part_size = 15
    AND p0.part_type LIKE '%BRASS'
    AND s.nation_key = n.nation_key
    AND n.region_key = r.region_key
    AND r.region_name = 'EUROPE'
    AND ps.cost = p.minsupplycost
ORDER BY
    s.account_balance DESC,
    n.nation_name,
    s.supplier_name,
    p0.part_key
limit 100;