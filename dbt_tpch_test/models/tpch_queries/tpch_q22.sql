with c as (
  select 
    * 
  from 
    {{ref("stg_tpch_customer") }}
), 
o as (
  select 
    * 
  from 
    {{ref("stg_tpch_orders") }}
), 
avg_balance AS (
  SELECT 
    avg(c.account_balance) AS avg_acctbal 
  FROM 
    c 
  WHERE 
    c.account_balance > 0.00 
    AND substring(c.phone_number, 1, 2) IN (
      '13', '31', '23', '29', '30', '18', '17'
    )
) 
SELECT 
  substring(c.phone_number, 1, 2) AS cntrycode, 
  count(*) AS numcust, 
  sum(c.account_balance) AS totacctbal 
FROM 
  c 
WHERE 
  substring(c.phone_number, 1, 2) IN (
    '13', '31', '23', '29', '30', '18', '17'
  ) 
  AND c.account_balance > (
    SELECT 
      avg_acctbal 
    FROM 
      avg_balance
  ) 
  AND NOT EXISTS (
    SELECT 
      1 
    FROM 
      o 
    WHERE 
      o.customer_key = c.customer_key
  ) 
GROUP BY 
  substring(c.phone_number, 1, 2) 
ORDER BY 
  cntrycode;
