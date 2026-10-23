insert into users (name, email, phone, role)
select
    'Пользователь ' || g,
    'user' || g || '@example.com',
    '+7' || floor(900000000 + random() * 100000000)::int,
    CASE WHEN random() < 0.2 THEN 'buyer' ELSE 'seller' END
FROM generate_series(1, 2000) AS g;

insert into orders (user_id ,status, total_amount)
select
    floor(1 + random() * 2000)::int,
    case
        when random() < 0.20 then 'Принят'
        when random() < 0.50 then 'Оплачено'
        when random() < 0.80 then 'На сборке'
        else 'Доставлен'
        end,
    floor(50 + random() * 1111)
from generate_series(1, 10000) as g;

insert into sellers (user_id, store_name, description)
select
    floor(1 + random() * 2000)::int,
    'Магазин№' || g,
    'Текст' || g
from generate_series(1, 400) as g;

insert into categories (parent_id, name)
select
    g,
    'Имя ' || g
from generate_series(1, 20) as g;

insert into addresses (user_id, city, street, house, apartment)
select
    floor(1 + random() * 2000)::int,
    'Город№' || floor(1 + random() * 200)::int,
    'Улица№' || floor(1 + random() * 300)::int,
    'Дом№' || floor(1 + random() * 100)::int,
    'Квартира№' || floor(1 + random() * 300)::int
from generate_series(1, 2000) as g;

insert into products (seller_id, category_id, title, description, price)
select
    floor(1 + random() * 400)::int,
    floor(1 + random() * 20)::int,
    'Название№' || g,
    'Описание№' || g,
    (1 + random() * 10000)::numeric(12,2)
from generate_series(1, 10000) as g;

insert into deliveries (order_id, address_id, delivery_status)
select
    g,
    floor(1 + random() * 2000)::int,
    CASE WHEN random() < 0.05 THEN 'Ждёт' ELSE 'В пути' END
from generate_series(1, 10000) as g;

insert into payments (order_id, amount, status)
select
    g,
    floor(1 + random() * 30)::int,
    CASE WHEN random() < 0.45 THEN 'Ждёт оплаты' ELSE 'Оплачено' END
from generate_series(1, 10000) as g;

insert into stock (product_id, quantity)
select
    g,
    floor(1 + random() * 2500)::int
from generate_series(1, 10000) as g;

insert into carts (user_id)
select
    floor(1 + random() * 2000)::int
from generate_series(1, 1000) as g;

insert into cart_items (cart_id, product_id, quantity)
select
    g,
    floor(1 + random() * 10000)::int,
    floor(1 + random() * 20)::int
from generate_series(1, 1000) as g;

insert into order_items (order_id, product_id, quantity, unit_price)
select
    g,
    floor(1 + random() * 10000)::int,
    floor(1 + random() * 20)::int,
    (1 + random() * 20000)::numeric(12,2)

from generate_series(1, 10000) as g;

insert into reviews (user_id, product_id, score, comment)
select
    floor(1 + random() * 2000)::int,
    floor(1 + random() * 10000)::int,
    floor(50 + random() * 20000)::int,
    'Комментарий' || g
from generate_series(1, 10000) as g;
