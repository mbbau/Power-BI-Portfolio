# Sales Dashboard

This project showcases an end-to-end Business Intelligence solution to analyze sales data. It includes the construction of an ETL process using SQL Stored Procedures to build a simplified Data Warehouse. From there, we define key metrics to evaluate and monitor sales performance. Finally, we design an interactive dashboard to visualize these insights and provide business context.

## Contents

- SQL Scripts for staging and transformation
- Data Warehouse schema
- Power BI Dashboard (.pbix)
- Dashboard background design
- Screenshots and demo

## Technologies

- SQL Server 2019
- T-SQL Stored Procedures
- Power BI
- AdventureWorks 2019 (sample dataset)

## Business Questions Answered

- What are the total sales and how have they evolved over time?
- Which products and categories drive the most revenue?
- Which regions perform better and why?
- How does customer behavior impact sales?

## About

This dashboard was developed as part of the BI portfolio for Denovo Studios, and is also used in the author's personal portfolio to showcase technical and analytical skills.

# Data Modeling

Data modeling is the process of designing tables and relationships between them in order to answer all relevant business questions from stakeholders—while being optimized for performance and cost-efficiency.
In other words, our main goal is to provide accurate answers using the minimum amount of computational resources and storage.

This model, composed of fact and dimension tables, is designed to mirror the real-world process we are analyzing—in this case, **sales**.
The key difference compared to the architecture of a transactional system lies in the purpose of each: transactional databases are optimized for atomic operations (create, update, delete), whereas analytical models are optimized for reading and aggregating large volumes of data.

While transactional systems can be used to answer analytical questions, doing so is often resource-intensive due to their normalized structure, which requires multiple joins and complex queries.

That’s why we’ve built this star-schema model: to isolate only the relevant information and store it in a way that allows us to answer questions—such as “What was the best-selling product last month?”—as efficiently as possible.

The following diagram represents the model used in this project:

![star schema](data_model.png)

## Star Schema Tables and Columns

Below is an overview of the fact and dimension tables included in the data model, along with the key columns and their data types:

<pre> ```yaml
tables:
  - name: fact_sales
    description: Fact table containing sales order details.
    columns:
      - name: sales_order_id
        type: INT
        description: Unique ID of the sales order.
      - name: sales_order_detail_id
        type: INT
        description: ID of the item line within the order.
      - name: order_date
        type: DATE
        description: Date the order was placed.
      - name: customer_key
        type: INT
        description: Surrogate key referencing dim_customer.
      - name: territory_id
        type: INT
        description: Identifier for the sales territory.
      - name: product_id
        type: INT
        description: Product identifier from dim_product.
      - name: order_qty
        type: INT
        description: Quantity sold.
      - name: unit_price
        type: DECIMAL
        description: Sale price per unit.
      - name: unit_price_discount
        type: DECIMAL
        description: Discount applied per unit.
      - name: standard_cost
        type: DECIMAL
        description: Standard cost of the product.
      - name: revenue
        type: DECIMAL
        description: Total revenue after discount.
      - name: gross_margin
        type: DECIMAL
        description: Revenue minus standard cost.

  - name: dim_customer
    description: Dimension table storing customer information as a slowly changing dimension (Type 2).
    columns:
      - name: customer_key
        type: INT
        description: Surrogate key (primary key).
      - name: customer_id
        type: INT
        description: Business key from the source system.
      - name: customer_name
        type: VARCHAR
        description: Full name of the customer.
      - name: territory_id
        type: INT
        description: Foreign key to sales territory.
      - name: start_date
        type: DATE
        description: Start of the record validity.
      - name: end_date
        type: DATE (nullable)
        description: End of the record validity.
      - name: is_current
        type: BIT
        description: Flag indicating current active version.

  - name: dim_product
    description: Product dimension with attributes used for filtering and slicing.
    columns:
      - name: product_key
        type: INT
        description: Surrogate key (primary key).
      - name: product_id
        type: INT
        description: Business key from the source system.
      - name: product_name
        type: VARCHAR
        description: Name of the product.
      - name: product_number
        type: VARCHAR
        description: Unique product code or SKU.
      - name: list_price
        type: DECIMAL
        description: Listed price.
      - name: standard_cost
        type: DECIMAL
        description: Standard cost of the item.
      - name: color
        type: VARCHAR
        description: Color of the product.
      - name: discontinued_date
        type: DATE (nullable)
        description: Date the product was discontinued.
      - name: is_active
        type: BIT
        description: Indicates if the product is currently sold.

  - name: dim_territory
    description: Dimension for sales territories and regional groupings.
    columns:
      - name: territory_key
        type: INT
        description: Surrogate key (primary key).
      - name: territory_id
        type: INT
        description: Business key for the territory.
      - name: territory_name
        type: VARCHAR
        description: Name of the territory.
      - name: territory_group
        type: VARCHAR
        description: Territory group or classification.
      - name: country_region_code
        type: VARCHAR
        description: Country code associated with the territory.

  - name: dim_date
    description: Calendar dimension for time-based filtering and aggregations.
    columns:
      - name: date_key
        type: INT
        description: Surrogate key (primary key).
      - name: full_date
        type: DATE
        description: Full calendar date.
      - name: day_of_month
        type: INT
        description: Day of the month (1–31).
      - name: day_of_week_name
        type: VARCHAR
        description: Name of the weekday.
      - name: day_of_week_number
        type: INT
        description: Number of the weekday (1=Monday).
      - name: month_number
        type: INT
        description: Numeric month (1–12).
      - name: month_name
        type: VARCHAR
        description: Month name (e.g. January).
      - name: quarter_number
        type: INT
        description: Quarter (1–4).
      - name: year_number
        type: INT
        description: Year (e.g. 2023).

 ``` </pre>

This marks the end of the modeling phase, where we defined a set of tables and relationships that allow us to answer key business questions related to the process under analysis.

Now that the data model has been established, the next step is to implement a set of transformations. In this project, they are developed in SQL and aim to:

1. Collect data from its original source,
2. Transform it into the desired analytical structure,
3. Store it in a new database (the data warehouse).

This data warehouse becomes the foundation from which we can build reports and dashboards to track business performance in a consistent and optimized way.
