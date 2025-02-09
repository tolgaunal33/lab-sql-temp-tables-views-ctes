-- First, create a view that summarizes rental information for each customer...
CREATE VIEW rental_summary_view AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
    c.email, 
    COUNT(r.rental_id) AS rental_count 
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid)
CREATE TEMPORARY TABLE temp_total_paid AS
SELECT 
    r.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary_view r 
JOIN payment p ON r.customer_id = p.customer_id
GROUP BY r.customer_id;

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table
WITH customer_summary AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.email,
        r.rental_count,
        t.total_paid
    FROM customer c
    JOIN rental_summary_view r ON c.customer_id = r.customer_id
    JOIN temp_total_paid t ON c.customer_id = t.customer_id
)
SELECT * FROM customer_summary;
