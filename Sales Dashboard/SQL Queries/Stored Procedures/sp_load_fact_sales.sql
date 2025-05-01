USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_fact_sales
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpiar fact table antes de cargar
    TRUNCATE TABLE dbo.fact_sales;

    -- Insertar los datos calculados
    INSERT INTO dbo.fact_sales (
        sales_order_id,
        sales_order_detail_id,
        order_date,
        customer_id,
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
        soh.customer_id,
        soh.territory_id,
        sod.product_id,
        sod.order_qty,
        sod.unit_price,
        sod.unit_price_discount,
        p.standard_cost,
        -- Revenue calculation
        (sod.unit_price * sod.order_qty * (1 - sod.unit_price_discount)) AS revenue,
        -- Gross Margin calculation
        ((sod.unit_price * sod.order_qty * (1 - sod.unit_price_discount)) - (p.standard_cost * sod.order_qty)) AS gross_margin
    FROM dbo.stg_salesorderdetail sod
    INNER JOIN dbo.stg_salesorderheader soh ON sod.sales_order_id = soh.sales_order_id
    INNER JOIN dbo.stg_product p ON sod.product_id = p.product_id;
END;
GO
