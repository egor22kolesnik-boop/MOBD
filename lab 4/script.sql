-- Лабораторная работа №4. Оконные функции и аналитика данных
-- База данных: marketplace

-- 1. Рейтинг товаров по цене внутри категории.
SELECT
    c.name AS category,
    p.title,
    p.price,
    ROW_NUMBER() OVER (
        PARTITION BY p.category_id
        ORDER BY p.price DESC
    ) AS row_number_by_price,
    RANK() OVER (
        PARTITION BY p.category_id
        ORDER BY p.price DESC
    ) AS rank_by_price,
    DENSE_RANK() OVER (
        PARTITION BY p.category_id
        ORDER BY p.price DESC
    ) AS dense_rank_by_price
FROM products AS p
JOIN categories AS c ON c.id = p.category_id
ORDER BY c.name, p.price DESC;

-- 2. Три самых дорогих товара в каждой категории.
WITH ranked_products AS (
    SELECT
        c.name AS category,
        p.title,
        p.price,
        ROW_NUMBER() OVER (
            PARTITION BY p.category_id
            ORDER BY p.price DESC
        ) AS price_position
    FROM products AS p
    JOIN categories AS c ON c.id = p.category_id
)
SELECT category, title, price, price_position
FROM ranked_products
WHERE price_position <= 3
ORDER BY category, price_position;

-- 3. Дневная выручка и нарастающий итог.
WITH daily_revenue AS (
    SELECT
        o.created_at::date AS day,
        SUM(oi.quantity * oi.unit_price) AS day_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.id
    GROUP BY o.created_at::date
)
SELECT
    day,
    day_revenue,
    SUM(day_revenue) OVER (ORDER BY day) AS running_total
FROM daily_revenue
ORDER BY day;

-- 4. Доля выручки каждого продавца в выручке своей категории.
WITH seller_category_revenue AS (
    SELECT
        p.category_id,
        p.seller_id,
        SUM(oi.quantity * oi.unit_price) AS seller_revenue
    FROM products AS p
    JOIN order_items AS oi ON oi.product_id = p.id
    GROUP BY p.category_id, p.seller_id
)
SELECT
    c.name AS category,
    s.store_name,
    scr.seller_revenue,
    SUM(scr.seller_revenue) OVER (
        PARTITION BY scr.category_id
    ) AS category_revenue,
    ROUND(
        100.0 * scr.seller_revenue
        / SUM(scr.seller_revenue) OVER (PARTITION BY scr.category_id),
        2
    ) AS category_revenue_share_pct
FROM seller_category_revenue AS scr
JOIN categories AS c ON c.id = scr.category_id
JOIN sellers AS s ON s.id = scr.seller_id
ORDER BY c.name, category_revenue_share_pct DESC;

-- 5. Сравнение дневной выручки с предыдущим и следующим днём.
WITH daily_revenue AS (
    SELECT
        o.created_at::date AS day,
        SUM(oi.quantity * oi.unit_price) AS day_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.id
    GROUP BY o.created_at::date
), revenue_with_neighbors AS (
    SELECT
        day,
        day_revenue,
        LAG(day_revenue) OVER (ORDER BY day) AS previous_day_revenue,
        LEAD(day_revenue) OVER (ORDER BY day) AS next_day_revenue
    FROM daily_revenue
)
SELECT
    day,
    day_revenue,
    previous_day_revenue,
    day_revenue - previous_day_revenue AS growth_from_previous_day,
    next_day_revenue
FROM revenue_with_neighbors
ORDER BY day;

-- 6а. Обычная группировка: по одной строке на категорию.
SELECT
    c.name AS category,
    COUNT(*) AS products_count,
    ROUND(AVG(p.price), 2) AS avg_price
FROM products AS p
JOIN categories AS c ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY products_count DESC, category;

-- 6б. Оконная функция: детали товаров сохраняются вместе с показателями категории.
SELECT
    c.name AS category,
    p.title,
    p.price,
    COUNT(*) OVER (PARTITION BY p.category_id) AS products_count,
    ROUND(AVG(p.price) OVER (PARTITION BY p.category_id), 2) AS avg_price
FROM products AS p
JOIN categories AS c ON c.id = p.category_id
ORDER BY c.name, p.price DESC;
