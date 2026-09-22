{% test sales_positive(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ adapter.quote(column_name) }} < 0

{% endtest %}