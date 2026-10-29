SELECT p.title, c.name AS category, s.store_name
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN sellers s ON p.seller_id = s.id;

SELECT p.title
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
WHERE r.id IS NULL;

SELECT c.name, COUNT(p.id) AS products_count,AVG(p.price) AS avg_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name;

SELECT s.store_name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM sellers s
JOIN products p ON p.seller_id = s.id
JOIN order_items oi ON oi.product_id = p.id
GROUP BY s.id, s.store_name
HAVING SUM(oi.quantity * oi.unit_price) > 10000;

SELECT title, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT title
FROM products
WHERE category_id IN (
    SELECT id FROM categories WHERE name = 'Ноутбуки'
);

SELECT store_name
FROM sellers s
WHERE EXISTS (
    SELECT 1 FROM products p WHERE p.seller_id = s.id
);

WITH stats AS (
    SELECT seller_id, COUNT(*) AS total
    FROM products
    GROUP BY seller_id
)
SELECT s.store_name, stats.total
FROM stats
JOIN sellers s ON s.id = stats.seller_id;

WITH RECURSIVE tree AS (
    SELECT id, name, parent_id
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id, c.name, c.parent_id
    FROM categories c
    JOIN tree t ON c.parent_id = t.id
)
SELECT * FROM tree;

CREATE VIEW seller_stats AS
SELECT s.store_name, COUNT(p.id) AS products_count
FROM sellers s
LEFT JOIN products p ON p.seller_id = s.id
GROUP BY s.id, s.store_name;

SELECT * FROM seller_stats;

CREATE VIEW category_stats AS
SELECT c.name, COUNT(p.id) AS products_count,
AVG(p.price) AS avg_price
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name;

SELECT * FROM category_stats;


