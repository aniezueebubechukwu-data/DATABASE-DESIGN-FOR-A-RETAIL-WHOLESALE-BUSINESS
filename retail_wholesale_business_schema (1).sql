-- =====================================================================
-- RETAIL / WHOLESALE BUSINESS SCHEMA

CREATE DATABASE RETAIL_WHOLESALE_BUSINESS_DB

BEGIN;
--suppliers,employees,customers, locations,products are independent tables

CREATE TABLE suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    phone       VARCHAR(30) UNIQUE,
    isActive    BIT NOT NULL DEFAULT 1,

    --Audit fields
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NOT NULL DEFAULT GETDATE() 

);

CREATE TABLE employees (
    employee_id  INT IDENTITY(1,1) PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    role         VARCHAR(50),
    isActive    BIT NOT NULL DEFAULT 1,

    --Audit fields
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NOT NULL DEFAULT GETDATE() 

);


CREATE TABLE customers (
    customer_id     INT IDENTITY(1,1) PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    phone           VARCHAR(30) CHECK(phone LIKE '080%'),
    customer_type   VARCHAR(30) CHECK(customer_type IN ('retail','wholesale')), -- e.g. 'retail', 'wholesale'
    isActive        BIT NOT NULL DEFAULT 1,

    --Audit fields
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NOT NULL DEFAULT GETDATE() 
);


CREATE TABLE locations (
    location_id     INT IDENTITY(1,1) PRIMARY KEY,
    type            VARCHAR(50) CHECK(type IN ('shop', 'warehouse'))  -- e.g. 'shop', 'warehouse'
);

DELETE locations

CREATE TABLE products (
    product_id      INT IDENTITY(1,1) PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    category        VARCHAR(80),
    retail_price    NUMERIC(10,2) NOT NULL CHECK (retail_price >= 0),
    wholesale_price NUMERIC(10,2) NOT NULL CHECK (wholesale_price >= 0)
);

-- ---------------------------------------------------------------------
-- Purchasing (supplier -> business)
-- ---------------------------------------------------------------------

--Table: purchases
--Design: one supplier can get many purchases
CREATE TABLE purchases (
    purchase_id     INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id     INT NOT NULL,
    purchase_date   DATE NOT NULL DEFAULT GETDATE(),
    payment_status  VARCHAR(30) CHECK(payment_status IN ('paid', 'pending', 'partial')),-- e.g. 'paid', 'pending', 'partial'

    --FOREIGN KEY
    CONSTRAINT FK_purchase_supplier
    FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id)

);

--Table: purchase_items
--Design: many purchased items/products are contained in one purchase basket
CREATE TABLE purchase_items (
    purchase_item_id INT IDENTITY(1,1) PRIMARY KEY,
    purchase_id      INT NOT NULL,
    product_id       INT NOT NULL,
    quantity         INT NOT NULL CHECK (quantity > 0),
    unit_cost        NUMERIC(10,2) NOT NULL CHECK (unit_cost >= 0),

    --FOREIGN KEY
    CONSTRAINT FK_purchase_items_purchases
    FOREIGN KEY(purchase_id) REFERENCES purchases(purchase_id) ON DELETE CASCADE,

    CONSTRAINT FK_purchase_items_products
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

-- ---------------------------------------------------------------------
-- Inventory (stock per product per location)
-- ---------------------------------------------------------------------
--Table: inventory
--Design: an inventory contains many products and belong to 2 locations(shop & warehouse)
CREATE TABLE inventory (
    inventory_id      INT IDENTITY(1,1) PRIMARY KEY,
    product_id        INT NOT NULL UNIQUE,
    location_id       INT NOT NULL,
    quantity_on_hand  INT NOT NULL DEFAULT 0 CHECK (quantity_on_hand >= 0),
  

     --FOREIGN KEY
    CONSTRAINT FK_inventory_products
    FOREIGN KEY(product_id) REFERENCES products(product_id),

    CONSTRAINT FK_inventory_locations
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

-- ---------------------------------------------------------------------
-- Sales (business -> customer)
-- ---------------------------------------------------------------------
--Table: sales
--Design: many sales can be made by one customer, entered by one employee, in one location
CREATE TABLE sales (
    sale_id       INT IDENTITY(1,1) PRIMARY KEY,
    customer_id   INT NOT NULL,
    employee_id   INT NOT NULL,
    location_id   INT NOT NULL,
    sale_date     DATE NOT NULL DEFAULT GETDATE(),
    sale_type     VARCHAR(30) CHECK(sale_type IN ('retail', 'wholesale')),-- e.g. 'retail', 'wholesale'
    status        VARCHAR(30) CHECK(status IN ('completed', 'pending', 'cancelled')),-- e.g. 'completed', 'pending', 'cancelled'

     --FOREIGN KEY
    CONSTRAINT FK_sales_customers
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),

    CONSTRAINT FK_sales_locations
    FOREIGN KEY(location_id) REFERENCES locations(location_id),

    CONSTRAINT FK_sales_employees
    FOREIGN KEY(employee_id) REFERENCES employees(employee_id)

);


--Table: sale_items
--Design: many sales_items can belong to one sales basket, one product can belong to multiple sales_item

CREATE TABLE sale_items (
    sale_item_id        INT IDENTITY(1,1) PRIMARY KEY,
    sale_id             INT NOT NULL,
    product_id          INT NOT NULL ,
    quantity            INT NOT NULL CHECK (quantity > 0),
    unit_price          NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    

     --FOREIGN KEY
    CONSTRAINT FK_sale_items_sales
    FOREIGN KEY(sale_id) REFERENCES sales(sale_id) ON DELETE CASCADE,

    CONSTRAINT FK_sale_items_products
    FOREIGN KEY(product_id) REFERENCES products(product_id)

);

--Table: payments
--Design: a sale can have many payments. payment can be done in part, or through transfer, cash or POS
--thereby generating different payment_id for the same sale_id

CREATE TABLE payments (
    payment_id    INT IDENTITY(1,1) PRIMARY KEY,
    sale_id       INT NOT NULL,
    amount        NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    method        VARCHAR(30) CHECK (method IN ('cash', 'transfer', 'POS')), -- e.g. 'cash', 'transfer', 'pos'
    payment_date  DATE NOT NULL DEFAULT GETDATE(),
    payment_status VARCHAR(30) NOT NULL CHECK (payment_status IN ('partial payment', 'paid', 'credit')), -- 'partial payment', 'paid', 'credit'

    --FOREIGN KEY
    CONSTRAINT FK_payments_sales
    FOREIGN KEY(sale_id) REFERENCES sales(sale_id) ON DELETE CASCADE

);

--Table: dispatch
--Design: A maximum of One sale will be dispatched by one dispatch driver
CREATE TABLE dispatch (
    dispatch_id       INT IDENTITY(1,1) PRIMARY KEY,
    sale_id           INT NOT NULL,
    destination_state VARCHAR(80),
    delivery_status   VARCHAR(30) CHECK(delivery_status IN ('pending', 'in_transit', 'delivered')), -- e.g. 'pending', 'in_transit', 'delivered'

    --FOREIGN KEY
    CONSTRAINT FK_dispatch_sales
    FOREIGN KEY(sale_id) REFERENCES sales(sale_id) ON DELETE CASCADE

);


CREATE INDEX idx_purchases_supplier_id       ON purchases(supplier_id);
CREATE INDEX idx_purchase_items_purchase_id  ON purchase_items(purchase_id);
CREATE INDEX idx_purchase_items_product_id   ON purchase_items(product_id);
CREATE INDEX idx_inventory_product_id        ON inventory(product_id);
CREATE INDEX idx_inventory_location_id       ON inventory(location_id);
CREATE INDEX idx_sales_customer_id           ON sales(customer_id);
CREATE INDEX idx_sales_employee_id           ON sales(employee_id);
CREATE INDEX idx_sales_location_id           ON sales(location_id);
CREATE INDEX idx_sale_items_sale_id          ON sale_items(sale_id);
CREATE INDEX idx_sale_items_product_id       ON sale_items(product_id);
CREATE INDEX idx_payments_sale_id            ON payments(sale_id);
CREATE INDEX idx_dispatch_sale_id            ON dispatch(sale_id);

END
--COMMIT;
