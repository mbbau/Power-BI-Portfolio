CREATE OR ALTER PROCEDURE dbo.sp_load_dim_product_subcategory
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.dim_product_subcategory;

    INSERT INTO dbo.dim_product_subcategory (
        product_subcategory_id,
        product_subcategory_name,
        product_category_name
    )
    SELECT
        psc.ProductSubcategoryID,
        psc.Name AS product_subcategory_name,
        pc.Name AS product_category_name
    FROM AdventureWorks2022.Production.ProductSubcategory psc
    INNER JOIN AdventureWorks2022.Production.ProductCategory pc
        ON psc.ProductCategoryID = pc.ProductCategoryID;
END;
GO
