USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_stg_product
AS
BEGIN
    SET NOCOUNT ON;

    -- Clean Table Before new Load
    TRUNCATE TABLE dbo.stg_product;

    -- INSERT FROM AdventureWorks2022
    INSERT INTO dbo.stg_product (
        product_id,
        product_name,
        product_number,
        standard_cost,
        list_price,
        color,
        size,
        weight,
        product_subcategory_id,
        sell_start_date,
        sell_end_date,
        discontinued_date
    )
    SELECT
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.StandardCost,
        p.ListPrice,
        p.Color,
        p.Size,
        p.Weight,
        p.ProductSubcategoryID,
        p.SellStartDate,
        p.SellEndDate,
        p.DiscontinuedDate
    FROM AdventureWorks2022.Production.Product p;
END;
GO
