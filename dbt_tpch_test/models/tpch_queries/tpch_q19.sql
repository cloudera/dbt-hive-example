WITH l AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_lineitem") }}
),
p AS (
    SELECT
        *
    FROM
        {{ ref("stg_tpch_part") }}
)
SELECT
    SUM(l.extended_price * (1 - l.discount_percentage)) AS revenue
FROM
    l,
    p
WHERE
    p.part_key = l.part_key
    and l.ship_mode in ('AIR', 'AIR REG')
    and l.ship_instructions = 'DELIVER IN PERSON'
    and (
            (
                p.part_brand = 'Brand#12'
                AND p.part_container IN ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
                AND l.quantity >= 1
                AND l.quantity <= 1 + 10
                AND p.part_size BETWEEN 1 AND 5
            )
            or
            (
                p.part_brand = 'Brand#23'
                AND p.part_container IN ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
                AND l.quantity >= 10
                AND l.quantity <= 10 + 10
                AND p.part_size BETWEEN 1 AND 10
            )
            or
            (
                p.part_brand = 'Brand#34'
                AND p.part_container IN ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
                AND l.quantity >= 20
                AND l.quantity <= 20 + 10
                AND p.part_size BETWEEN 1 AND 15
            )
        );
    