-- Group work
CREATE DATABASE bookstore_db;
USE bookstore_db;

-- TABLE 1
CREATE TABLE country (
  country_id INT AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(100) NOT NULL
);

-- TABLE 2
CREATE TABLE address_status (
  status_id INT AUTO_INCREMENT PRIMARY KEY,
  status_description VARCHAR(50) NOT NULL
);

-- TABLE 3
CREATE TABLE address (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  street VARCHAR(255),
  city VARCHAR(100),
  postal_code VARCHAR(20),
  country_id INT,
  FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- TABLE 4
CREATE TABLE customer (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20)
);

-- TABLE 5
CREATE TABLE customer_address (
  cust_address_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  address_id INT,
  status_id INT,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (address_id) REFERENCES address(address_id),
  FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- TABLE 6
CREATE TABLE publisher (
  publisher_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  contact_email VARCHAR(100)
);

-- TABLE 7
CREATE TABLE book_language (
  language_id INT AUTO_INCREMENT PRIMARY KEY,
  language_name VARCHAR(50)
);

-- TABLE 8
CREATE TABLE book (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  isbn VARCHAR(20) UNIQUE,
  publish_date DATE,
  price DECIMAL(10,2),
  publisher_id INT,
  language_id INT,
  FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
  FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- TABLE 9
CREATE TABLE author (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100)
);

-- TABLE 10
CREATE TABLE book_author (
  book_id INT,
  author_id INT,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id),
  FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- TABLE 11
CREATE TABLE cust_order (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status_id INT,
  shipping_method_id INT,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (status_id) REFERENCES order_status(status_id),
  FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id)
);

-- TABLE 12
CREATE TABLE order_line (
  order_line_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  book_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- TABLE 13
CREATE TABLE shipping_method (
  method_id INT AUTO_INCREMENT PRIMARY KEY,
  method_name VARCHAR(100),
  cost DECIMAL(8,2)
);

-- TABLE 14
CREATE TABLE order_status (
  status_id INT AUTO_INCREMENT PRIMARY KEY,
  status_description VARCHAR(50)
);

-- TABLE 15
CREATE TABLE order_history (
  history_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  status_id INT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
  FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- ROLES (READ ONLY)
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'read_pass';
GRANT SELECT ON bookstore_db.* TO 'readonly_user'@'localhost';

-- ADMINS ROLES
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'admin_user'@'localhost';

-- INSERTING VALUES
INSERT INTO country (country_name) 
VALUES
('Kenya'), ('Uganda'), ('Tanzania');

INSERT INTO address_status (status_description) VALUES
('current'), ('old');

INSERT INTO address (street, city, postal_code, country_id) VALUES
('Reading street', 'Nairobi', '00100', 1),
('Read Avenue', 'Kampala', '00200', 2),
('Moshi Avenue', 'Tanzania', '00300', 2);

INSERT INTO customer (first_name, last_name, email, phone) VALUES
('Terry', 'Anne', 'terryanne45@gmail.com', '0700111222'),
('Upside', 'Down', 'upsidedown23@gmail.com', '0711223344'),
('Chinese', 'Deon', 'chinesedeon67@gmail.com', '0743223344');

INSERT INTO customer_address (customer_id, address_id, status_id)
 VALUES
(1, 1, 1),
(2, 2, 1);

INSERT INTO book_language (language_name) VALUES
('English'), ('Swahili');

INSERT INTO book (title, isbn, publish_date, price, publisher_id, language_id) VALUES
('Learning SQL', '978-1-23-456789-0', '2020-01-01', 2500.00, 1, 1),
('Mastering Databases', '978-0-12-345678-9', '2021-06-15', 3000.00, 2, 1);

INSERT INTO author (first_name, last_name) VALUES
('Terry', 'AnnW'),
('Upsidedown', 'Hillary');

INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2);

INSERT INTO order_status (status_description) VALUES
('pending'), ('shipped'), ('delivered');


INSERT INTO shipping_method (method_name, cost) VALUES
('Courier', 500.00), ('Pickup', 0.00);

INSERT INTO cust_order (customer_id, status_id, shipping_method_id) VALUES
(1, 1, 1),
(2, 3, 2);

INSERT INTO order_line (order_id, book_id, quantity, unit_price) VALUES
(1, 1, 2, 2500.00),
 (2, 2, 1, 3000.00);

 INSERT INTO order_history (order_id, status_id) VALUES
 (1, 1),
 (1, 2),
 (2, 3);



INSERT INTO publisher (name, contact_email) VALUES
('Pearson Publishers', 'contact@pearson.com'),
('Longhorn Kenya', 'info@longhorn.co.ke');


-- RETRIEVING DATA
SELECT b.title, SUM(ol.quantity) AS total_sold
FROM order_line ol
JOIN book b ON b.book_id = ol.book_id
GROUP BY b.title
ORDER BY total_sold DESC
LIMIT 5;
;


SELECT * FROM order_status;

