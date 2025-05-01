USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_dim_product
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpiar la dimensión antes de recargar (si lo hacemos full load)
    TRUNCATE TABLE dbo.dim_product;

    -- Insertar desde staging
    INSERT INTO dbo.dim_product (
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
        discontinued_date,
        is_active
    )
    SELECT
        product_id,
        product_name,
        product_number,
        standard_cost,
        list_price,
        color,
        size,
        weight,
        product_subcategory_id,
        CAST(sell_start_date AS DATE),
        CAST(sell_end_date AS DATE),
        CAST(discontinued_date AS DATE),
        CASE 
            WHEN sell_end_date IS NULL THEN 1 
            ELSE 0 
        END AS is_active
    FROM dbo.stg_product;
END;
GO
