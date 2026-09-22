{% test ship_date_after_order_date(model, order_date_column, ship_date_column) %}

SELECT *
FROM {{ model }}
WHERE {{ adapter.quote(ship_date_column) }}
    < {{ adapter.quote(order_date_column) }}

{% endtest %}