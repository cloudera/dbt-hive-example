SELECT
    return_flag,
    status_code,
    round(sum(quantity), 3)                                 AS sum_qty,
    round(sum(extended_price), 3)                            AS sum_stg_price,
    round(sum(extended_price*(1-discount_percentage)), 3)             AS sum_disc_price,
    round(sum(extended_price*(1-discount_percentage)*(1+tax_rate)), 3)   AS sum_charge,
    round(avg(quantity), 3)                                 AS avg_qty,
    round(avg(extended_price), 3)                            AS avg_price,
    round(avg(discount_percentage), 3)                                 AS avg_disc,
    count(*)                                        AS count_order
FROM
    {{ ref('stg_tpch_lineitem') }}
WHERE
    ship_date <= date_sub('1998-12-01', 93)
GROUP BY
    return_flag,
    status_code
ORDER BY
    return_flag,
    status_code;