USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_stg_territory
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.stg_territory;

    INSERT INTO dbo.stg_territory (
        territory_id,
        territory_name,
        country_region_code,
        territory_group
    )
    SELECT
        st.TerritoryID,
        st.Name,
        st.CountryRegionCode,
        st.[Group]
    FROM AdventureWorks2022.Sales.SalesTerritory st;
END;
GO
