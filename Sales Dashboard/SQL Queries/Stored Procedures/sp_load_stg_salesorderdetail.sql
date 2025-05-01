USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_stg_salesorderdetail
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.stg_salesorderdetail;

    INSERT INTO dbo.stg_salesorderdetail (
        sales_order_detail_id,
        sales_order_id,
        product_id,
        order_qty,
        unit_price,
        unit_price_discount
    )
    SELECT
        sod.SalesOrderDetailID,
        sod.SalesOrderID,
        sod.ProductID,
        sod.OrderQty,
        sod.UnitPrice,
        sod.UnitPriceDiscount
    FROM AdventureWorks2022.Sales.SalesOrderDetail sod;
END;
GO
