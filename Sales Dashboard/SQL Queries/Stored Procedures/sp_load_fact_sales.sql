USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_fact_sales
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.fact_sales;

    INSERT INTO dbo.fact_sales (
        sales_order_id,
        sales_order_detail_id,
        order_date,
        customer_key,
        territory_id,
        product_id,
        order_qty,
        unit_price,
        unit_price_discount,
        standard_cost,
        revenue,
        gross_margin
    )
    SELECT
        sod.sales_order_id,
        sod.sales_order_detail_id,
        soh.order_date,
        dc.customer_key,
        soh.territory_id,
        sod.product_id,
        sod.order_qty,
        sod.unit_price,
        sod.unit_price_discount,
        p.standard_cost,
        (sod.unit_price * sod.order_qty * (1 - sod.unit_price_discount)) AS revenue,
        ((sod.unit_price * sod.order_qty * (1 - sod.unit_price_discount)) - (p.standard_cost * sod.order_qty)) AS gross_margin
    FROM dbo.stg_salesorderdetail sod
    INNER JOIN dbo.stg_salesorderheader soh
        ON sod.sales_order_id = soh.sales_order_id
    INNER JOIN dbo.stg_product p
        ON sod.product_id = p.product_id
    INNER JOIN dbo.dim_customer dc
        ON soh.customer_id = dc.customer_id
        AND soh.order_date BETWEEN dc.start_date AND ISNULL(dc.end_date, '9999-12-31');
END;
GO
