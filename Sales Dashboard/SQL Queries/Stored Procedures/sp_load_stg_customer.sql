USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_stg_customer
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.stg_customer;

    INSERT INTO dbo.stg_customer (
        customer_id,
        customer_name,
        territory_id
    )
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS customer_name,
        c.TerritoryID
    FROM AdventureWorks2022.Sales.Customer c
    INNER JOIN AdventureWorks2022.Person.Person p
        ON c.PersonID = p.BusinessEntityID
    WHERE c.StoreID IS NULL;
END;
GO
