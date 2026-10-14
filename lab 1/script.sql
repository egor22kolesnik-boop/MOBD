/*drop table if exists users, sellers, categories, products, stock, carts, cart_items, order_items, payments, reviews, orders, deliveries, addresses;
*/

create table users (
    id integer generated always as identity primary key,
    name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(20) not null unique,
    role varchar(30) not null,
    created_at timestamp not null default now()
);

create table sellers (
    id integer generated always as identity primary key,
    user_id integer not null references users(id) on delete restrict,
    store_name varchar(100) not null unique,
    description text,
    created_at timestamp not null default now()
);

create table categories (
    id integer generated always as identity primary key,
    parent_id integer references categories(id) on delete restrict,
    name text not null unique
);

create table products (
    id integer generated always as identity primary key ,
    seller_id integer not null references sellers(id) on delete restrict,
    category_id integer not null references categories(id) on delete restrict,
    title varchar(100) not null,
    description text,
    price numeric(12,2) not null check (price > 0),
    is_active boolean not null default true,
    created_at timestamp not null default now()
);

create table orders (
    id integer generated always as identity primary key,
    user_id integer not null references users(id) on delete restrict,
    status varchar(100) not null,
    total_amount decimal not null,
    created_at timestamp not null default now()
);

create table stock (
    product_id integer primary key references products(id),
    quantity integer,
    updated_at timestamp not null default now()
);

create table carts (
    id integer generated always as identity primary key,
    user_id integer not null references users(id) on delete cascade,
    created_at timestamp not null default now()
);

create table cart_items (
    cart_id integer not null references carts(id) on delete cascade,
    product_id integer not null references products(id) on delete cascade,
    quantity integer
);

create table order_items (
    order_id integer not null references orders(id) on delete cascade,
    product_id integer not null references products(id) on delete restrict,
    quantity integer not null check (quantity > 0),
    unit_price numeric(12,2) not null check (unit_price > 0),
    primary key (order_id, product_id)
);

create table reviews (
    id integer generated always as identity primary key,
    user_id integer not null references users(id) on delete restrict,
    product_id integer not null references products(id) on delete cascade,
    score integer,
    comment text,
    created_at timestamp not null default now()
);

create table payments (
    id integer generated always as identity primary key,
    order_id integer not null references orders(id) on delete restrict,
    amount decimal,
    status varchar(20),
    paid_at timestamp not null default now()
);

create table addresses (
    id integer generated always as identity primary key,
    user_id integer not null references users(id) on delete cascade,
    city varchar(50),
    street varchar(50),
    house varchar(20),
    apartment varchar(50)
);

create table deliveries (
    id integer generated always as identity primary key,
    order_id integer not null references orders(id) on delete restrict,
    address_id integer not null references addresses(id) on delete restrict,
    delivery_status varchar(20),
    delivery_data timestamp not null default now()
);

