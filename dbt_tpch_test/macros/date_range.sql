{% macro test_date_range(model, column_name, min_date, max_date) %}

with meet_condition as(
  select *
  from {{ model }}
),

validation_errors as (
  select *
  from meet_condition
  where
    1 = 2

  {%- if min_date is not none %}
    
    or not {{ column_name }} >= '{{ min_date }}'
  {%- endif %}

  {%- if max_date is not none %}
   
    or not {{ column_name }} <=  '{{ max_date}}'
  {%- endif %}
)

select *
from validation_errors

{% endmacro %}
