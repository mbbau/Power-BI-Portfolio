USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_dim_customer
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_date DATE = '2010-01-01';

    -- Insertar nuevos clientes
    INSERT INTO dbo.dim_customer (
        customer_id,
        customer_name,
        territory_id,
        start_date,
        end_date,
        is_current
    )
    SELECT
        sc.customer_id,
        sc.customer_name,
        sc.territory_id,
        @start_date,
        NULL,
        1
    FROM dbo.stg_customer sc
    LEFT JOIN dbo.dim_customer dc
        ON sc.customer_id = dc.customer_id
        AND dc.is_current = 1
    WHERE dc.customer_id IS NULL;

    -- Cierre de versiones si hay cambios
    UPDATE dc
    SET
        end_date = @start_date,
        is_current = 0
    FROM dbo.dim_customer dc
    INNER JOIN dbo.stg_customer sc
        ON sc.customer_id = dc.customer_id
    WHERE dc.is_current = 1
      AND (
            sc.customer_name <> dc.customer_name OR
            ISNULL(sc.territory_id, -1) <> ISNULL(dc.territory_id, -1)
          );

    -- Insertar nueva versión si hubo cambio
    INSERT INTO dbo.dim_customer (
        customer_id,
        customer_name,
        territory_id,
        start_date,
        end_date,
        is_current
    )
    SELECT
        sc.customer_id,
        sc.customer_name,
        sc.territory_id,
        @start_date,
        NULL,
        1
    FROM dbo.stg_customer sc
    INNER JOIN dbo.dim_customer dc
        ON sc.customer_id = dc.customer_id
    WHERE dc.is_current = 0
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.dim_customer dc2
          WHERE dc2.customer_id = sc.customer_id
            AND dc2.is_current = 1
      );
END;
GO
