USE AdventureWorksDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_dim_date
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpiar si ya existía
    TRUNCATE TABLE dbo.dim_date;

    DECLARE @start_date DATE = '2010-01-01';
    DECLARE @end_date DATE = '2030-12-31';
    DECLARE @current_date DATE = @start_date;

    WHILE @current_date <= @end_date
    BEGIN
        INSERT INTO dbo.dim_date (
            date_key,
            full_date,
            day_of_month,
            month_number,
            month_name,
            quarter_number,
            year_number,
            day_of_week_number,
            day_of_week_name
        )
        VALUES (
            CAST(FORMAT(@current_date, 'yyyyMMdd') AS INT),
            @current_date,
            DATEPART(DAY, @current_date),
            DATEPART(MONTH, @current_date),
            DATENAME(MONTH, @current_date),
            DATEPART(QUARTER, @current_date),
            DATEPART(YEAR, @current_date),
            DATEPART(WEEKDAY, @current_date),
            DATENAME(WEEKDAY, @current_date)
        );

        SET @current_date = DATEADD(DAY, 1, @current_date);
    END
END;
GO
