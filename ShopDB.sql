/* MASTER-DETAIL demo for ShopDB
   Master: dbo.SalesOrders
   Detail: dbo.SalesOrderLines
*/

IF OBJECT_ID('dbo.SalesOrderLines', 'U') IS NOT NULL DROP TABLE dbo.SalesOrderLines;
IF OBJECT_ID('dbo.SalesOrders', 'U') IS NOT NULL DROP TABLE dbo.SalesOrders;
GO

CREATE TABLE dbo.SalesOrders (
    OrderID     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderDate   DATE NOT NULL CONSTRAINT DF_SalesOrders_OrderDate DEFAULT (GETDATE()),
    CustomerName NVARCHAR(100) NOT NULL,
    Status      NVARCHAR(20) NOT NULL CONSTRAINT DF_SalesOrders_Status DEFAULT ('Open')
);
GO

CREATE TABLE dbo.SalesOrderLines (
    LineID      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderID     INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Qty         INT NOT NULL CONSTRAINT CK_SalesOrderLines_Qty CHECK (Qty > 0),
    Price       DECIMAL(18,2) NOT NULL CONSTRAINT CK_SalesOrderLines_Price CHECK (Price >= 0),
    CONSTRAINT FK_SalesOrderLines_SalesOrders
        FOREIGN KEY (OrderID) REFERENCES dbo.SalesOrders(OrderID)
        ON DELETE CASCADE
);
GO

CREATE INDEX IX_SalesOrderLines_OrderID ON dbo.SalesOrderLines(OrderID);
GO

/* Seed data */
INSERT INTO dbo.SalesOrders (OrderDate, CustomerName, Status) VALUES
('2026-01-15', N'Gaming Ltd',  N'Open'),
('2026-01-16', N'Office OOD',  N'Open'),
('2026-01-17', N'Home Market', N'Closed');

INSERT INTO dbo.SalesOrderLines (OrderID, ProductName, Qty, Price) VALUES
(1, N'Gaming mouse', 2,  99.99),
(1, N'Keyboard',     1,  55.55),
(2, N'Office Mouse', 3, 122.00),
(2, N'Keyboard',     2,  55.55),
(3, N'Home Robot',   1, 25000.00);
GO

SELECT * FROM dbo.SalesOrders;
SELECT * FROM dbo.SalesOrderLines ORDER BY OrderID, LineID;