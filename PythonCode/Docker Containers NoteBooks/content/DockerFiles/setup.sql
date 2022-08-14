USE master
GO

DROP DATABASE IF EXISTS EMDDemo
GO

CREATE DATABASE EMDDemo
GO

USE EMDDemo
GO

CREATE TABLE dbo.DimCustomer(
    oid int identity(1,1) NOT NULL,
    CustomerName VARCHAR(256) NOT NULL,
    CustomerLastName VARCHAR(256) NOT NULL,
    DOB DATE NOT NULL,
    CONSTRAINT PK_DimCustomer PRIMARY KEY NONCLUSTERED(oid)
)
GO

INSERT INTO dbo.DimCustomer
(CustomerName, CustomerLastName, DOB)
VALUES
('Paul','McCartney','1944-01-01'),
('Ringo','Star','1943-01-01'),
('John','Lennon','1942-01-01'),
('George','Harrison','1943-01-01')
GO
