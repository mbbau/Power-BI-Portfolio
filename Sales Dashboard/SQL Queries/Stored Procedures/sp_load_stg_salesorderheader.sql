USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_stg_salesorderheader
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.stg_salesorderheader;

    INSERT INTO dbo.stg_salesorderheader (
        sales_order_id,
        order_date,
        customer_id,
        territory_id,
        total_due
    )
    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        soh.CustomerID,
        soh.TerritoryID,
        soh.TotalDue
    FROM AdventureWorks2022.Sales.SalesOrderHeader soh;
END;
GO
