# Microsoft Azure Supercloud Customers
  -- A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category listed in the products table.
  -- Write a query that identifies the customer IDs of these Supercloud customers.

## SQL Query

SELECT
    a.customer_id
FROM customer_contracts a
JOIN products b
    ON a.product_id = b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category) = (
    SELECT COUNT(DISTINCT product_category)
    FROM products
);

