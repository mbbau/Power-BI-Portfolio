-- Staging table for product

USE AdventureWorksDW;
GO

CREATE TABLE dbo.stg_product (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(255),
    product_number NVARCHAR(25),
    standard_cost MONEY,
    list_price MONEY,
    color NVARCHAR(50),
    size NVARCHAR(10),
    weight DECIMAL(10,2),
    product_subcategory_id INT,
    sell_start_date DATETIME,
    sell_end_date DATETIME,
    discontinued_date DATETIME
);
GO

-- Dimension table for product

USE AdventureWorksDW;
GO

CREATE TABLE dbo.dim_product (
    product_key INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    product_id INT NOT NULL, -- Natural Key
    product_name NVARCHAR(255),
    product_number NVARCHAR(25),
    standard_cost MONEY,
    list_price MONEY,
    color NVARCHAR(50),
    size NVARCHAR(10),
    weight DECIMAL(10,2),
    product_subcategory_id INT,
    sell_start_date DATE,
    sell_end_date DATE,
    discontinued_date DATE,
    is_active BIT
);
GO

-- Staging table for sales order header

USE AdventureWorksDW;
GO

CREATE TABLE dbo.stg_salesorderheader (
    sales_order_id INT PRIMARY KEY,
    order_date DATETIME,
    customer_id INT,
    territory_id INT,
    total_due MONEY
);
GO

-- Staging table for sales order details

USE AdventureWorksDW;
GO

CREATE TABLE dbo.stg_salesorderdetail (
    sales_order_detail_id INT PRIMARY KEY,
    sales_order_id INT,
    product_id INT,
    order_qty SMALLINT,
    unit_price MONEY,
    unit_price_discount MONEY
);
GO

-- Fact Table for sales

USE AdventureWorksDW;
GO

DROP TABLE IF EXISTS dbo.fact_sales;
GO

CREATE TABLE dbo.fact_sales (
    sales_order_detail_key INT IDENTITY(1,1) PRIMARY KEY,
    sales_order_id INT,
    sales_order_detail_id INT,
    order_date DATE,
    customer_key INT,
    territory_id INT,
    product_id INT,
    order_qty SMALLINT,
    unit_price MONEY,
    unit_price_discount MONEY,
    standard_cost MONEY,
    revenue MONEY,
    gross_margin MONEY
);
GO


-- Dimension table for Customers

USE AdventureWorksDW;
GO

CREATE TABLE dbo.dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name NVARCHAR(255),
    territory_id INT,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT NOT NULL
);
GO

-- Staging for Customer

USE AdventureWorksDW;
GO

CREATE TABLE dbo.stg_customer (
    customer_id INT PRIMARY KEY,
    customer_name NVARCHAR(255),
    territory_id INT,
    email_address NVARCHAR(255),
    phone_number NVARCHAR(25)
);
GO


-- Dimension Table for Customers

USE AdventureWorksDW;
GO

CREATE TABLE dbo.dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name NVARCHAR(255),
    territory_id INT,
    email_address NVARCHAR(255),
    phone_number NVARCHAR(25),
    start_date DATE NOT NULL,
    end_date DATE NULL,
    is_current BIT NOT NULL
);
GO

-- Staging table for Territory

USE AdventureWorksDW;
GO

CREATE TABLE dbo.stg_territory (
    territory_id INT PRIMARY KEY,
    territory_name NVARCHAR(50),
    country_region_code NVARCHAR(10),
    territory_group NVARCHAR(50)
);
GO


-- Dimension Table for Territory

USE AdventureWorksDW;
GO

CREATE TABLE dbo.dim_territory (
    territory_key INT IDENTITY(1,1) PRIMARY KEY,
    territory_id INT NOT NULL,
    territory_name NVARCHAR(50),
    country_region_code NVARCHAR(10),
    territory_group NVARCHAR(50)
);
GO


-- Dimension for dates

USE AdventureWorksDW;
GO

CREATE TABLE dbo.dim_date (
    date_key INT PRIMARY KEY, -- formato YYYYMMDD
    full_date DATE NOT NULL,
    day_of_month INT,
    month_number INT,
    month_name NVARCHAR(20),
    quarter_number INT,
    year_number INT,
    day_of_week_number INT,
    day_of_week_name NVARCHAR(20)
);
GO
