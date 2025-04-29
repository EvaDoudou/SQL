
USE AdventureWorksLT2022
go

--Write queries for following scenarios - Using AdventureWorks Database: 
--1. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, with no filter. 
Select ProductID, Name, Color, ListPrice 
FROM SalesLT.Product

--2. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, excludes the rows that ListPrice is 0.
SELECT ProductID, Name, Color, ListPrice
FROM SalesLT.Product
WHERE ListPrice != 0

--3. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM SalesLT.Product
WHERE Color IS NULL

--4. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM SalesLT.Product
WHERE Color IS NOT NULL

--5. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
SELECT ProductID, Name, Color, ListPrice
FROM SalesLT.Product
WHERE Color IS NOT NULL AND ListPrice > 0

--6. Write a query that concatenates the columns Name and Color from the Production.Product table by excluding the rows that are null for color.
SELECT Name + ' ' + Color AS ProductInfo
FROM SalesLT.Product
WHERE Color IS NOT NULL

--7. Write a query that generates the following result set  from Production.
-- NAME: LL Crankarm  --  COLOR: Black
SELECT 'Name: ' + name + ' -- COLOR: ' + Color AS ProductInfo
FROM SalesLT.Product
WHERE Color is not null

--8. Write a query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500
SELECT ProductID, Name
FROM SalesLT.Product
WHERE ProductID BETWEEN 400 AND 500

--9. Write a query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color in ('Black','Blue')

--10. Write a query to get a result set on products that begins with the letter S. 
SELECT Name
FROM SalesLT.Product
WHERE Name like 'S%'

--11. Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. Order the result set by the Name column. 
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name asc

--12. Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. Order the result set by the Name column. The products name should start with either 'A' or 'S'
SELECT Name, ListPrice
FROM SalesLT.Product
WHERE Name like '[S,A]%'
ORDER BY NAME ASC

--13. Write a query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name 
FROM SalesLT.Product
WHERE Name LIKE '[S,P,O]%' AND Name NOT LIKE '%K'
ORDER BY NAME ASC

--14. Write a query that retrieves unique colors from the table Production.Product. Order the results  in descending  manner.
SELECT DISTINCT Color
FROM SalesLT.Product
ORDER BY Color desc
