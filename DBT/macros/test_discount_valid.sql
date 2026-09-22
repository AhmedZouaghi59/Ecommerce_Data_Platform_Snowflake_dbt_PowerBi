{% test discount_valid(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ adapter.quote(column_name) }} < 0
   OR {{ adapter.quote(column_name) }} > 1

{% endtest %}