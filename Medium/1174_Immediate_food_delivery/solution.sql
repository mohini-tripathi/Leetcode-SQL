SELECT 
    ROUND(
        SUM(CASE WHEN order_type = 'immediate' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS immediate_percentage
FROM ( 
    SELECT 
        delivery_id, 
        customer_id,
        CASE 
            WHEN order_date = customer_pref_delivery_date THEN 'immediate'
            ELSE 'scheduled'
        END AS order_type
    FROM (
        SELECT 
            delivery_id, 
            customer_id, 
            order_date, 
            customer_pref_delivery_date
        FROM Delivery
        JOIN (
            SELECT 
                customer_id, 
                MIN(order_date) AS min_order_date
            FROM Delivery
            GROUP BY customer_id
        ) AS min_orders
        ON Delivery.customer_id = min_orders.customer_id 
        AND Delivery.order_date = min_orders.min_order_date
    ) AS first_order_table
) AS percentage_table;