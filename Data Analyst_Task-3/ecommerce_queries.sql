-- =========================================================================
-- TASK 3: SQL FOR DATA ANALYSIS - ECOMMERCE DB SETUP & ANALYSIS
-- =========================================================================

-- 1. DATABASE SCHEMA SETUP & DATA INSERTION
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert Mock Data for Users
INSERT INTO users (user_id, name, email, signup_date) VALUES
(1, 'Alice Johnson', 'alice@example.com', '2026-01-15'),
(2, 'Bob Smith', 'bob@example.com', '2026-02-20'),
(3, 'Charlie Brown', 'charlie@example.com', '2026-03-05'),
(4, 'David Miller', 'david@example.com', '2026-03-12'),
(5, 'Eva Green', NULL, '2026-04-01');

-- Insert Mock Data for Orders
INSERT INTO orders (order_id, user_id, order_date, total_amount) VALUES
(101, 1, '2026-01-20', 150.00),
(102, 1, '2026-02-15', 45.50),
(103, 2, '2026-02-22', 200.00),
(104, 3, '2026-03-10', 89.99),
(105, 1, '2026-03-15', 120.00),
(106, 2, '2026-04-05', 310.00);

-- =========================================================================
-- ANALYSIS TASKS (MINI GUIDE)
-- =========================================================================

-- a. Use SELECT, WHERE, ORDER BY, GROUP BY, and HAVING
SELECT user_id, SUM(total_amount) AS total_spent
FROM orders
WHERE order_date >= '2026-01-01'
GROUP BY user_id
HAVING SUM(total_amount) > 100
ORDER BY total_spent DESC;

-- b. Use JOINS (INNER, LEFT) to map users to their orders
SELECT u.user_id, u.name, o.order_id, o.total_amount
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

-- c. Write subqueries
SELECT name, email 
FROM users 
WHERE user_id IN (
    SELECT user_id 
    FROM orders 
    WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
);

-- d. Use aggregate functions (SUM, AVG) to calculate ARPU
SELECT 
    SUM(total_amount) AS total_revenue,
    COUNT(DISTINCT user_id) AS total_active_users,
    (SUM(total_amount) / COUNT(DISTINCT user_id)) AS average_revenue_per_user
FROM orders;

-- e. Create views for analysis
CREATE VIEW customer_spending_summary AS
SELECT u.user_id, u.name, COALESCE(u.email, 'No Email Provided') AS clean_email,
       COUNT(o.order_id) AS total_orders,
       SUM(COALESCE(o.total_amount, 0)) AS lifetime_value
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name, u.email;

-- f. Optimize queries with indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_date ON orders(order_date);
