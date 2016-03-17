-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS employees, customers, products, frequencies, invoices;

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  email_address VARCHAR(255)
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  account_number VARCHAR(20)
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE frequencies (
  id SERIAL PRIMARY KEY,
  frequency VARCHAR(15)
);

CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,
  invoice_num VARCHAR(10),
  employee_id INT REFERENCES employees(id),
  customer_id INT REFERENCES customers(id),
  product_id INT REFERENCES products(id),
  sale_date DATE,
  sale_amount MONEY,
  units_sold INTEGER,
  frequency_id INT REFERENCES frequencies(id)
);
