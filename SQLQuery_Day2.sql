Use AdventureWorks
go

--1. How many products can you find in the Production.Product table?
SELECT COUNT(ProductID) AS COUNTEDPRODUCT
FROM Production.Product

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) AS ProductsWithCategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.ProductSubcategoryID CountedProducts
SELECT ProductSubcategoryID,COUNT(ProductID) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

--4. How many products that do not have a product subcategory.
SELECT COUNT(ProductID) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity) AS SUM
FROM Production.ProductInventory
GROUP BY ProductID

--6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.ProductID    TheSum
SELECT ProductID, SUM(Quantity) AS TheSUM
FROM Production.ProductInventory
WHERE LocationID = 40  
GROUP BY ProductID
HAVING SUM(Quantity)  < 100

--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100 Shelf      ProductID    TheSum
SELECT ProductID, SUM(Quantity) AS TheSUM
FROM Production.ProductInventory
WHERE LocationID = 40  
GROUP BY ProductID
HAVING SUM(Quantity)  < 100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
WHERE LocationID = 10  
GROUP BY ProductID

--9. Write query to see the average quantity of  products by shelf  from the table Production.ProductInventory ProductID   Shelf      TheAvg
SELECT ProductID, Shelf, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory ProductID   Shelf      TheAvg
SELECT ProductID, Shelf, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.Color                        Class              TheCount          AvgPrice
SELECT Color,Class,COUNT(ProductID) AS TheCount, AVG(ListPrice) AS AVGPrice
FROM Production.Product
Where Color IS NOT Null and Class IS NOT Null
GROUP BY Color,Class

--12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. Country                        Province
SELECT c.Name as Country, p.Name as Province
FROM Person.CountryRegion c join Person.StateProvince p on c.CountryRegionCode = p.CountryRegionCode 

--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following. Country                        Province
SELECT c.Name as Country, p.Name as Province
FROM Person.CountryRegion c join Person.StateProvince p on c.CountryRegionCode = p.CountryRegionCode 
Where c.Name in ('Germany','Canada')
Order by c.Name, p.Name

USE Northwind
GO
--14. List all Products that has been sold at least once in last 27 years.
SELECT DISTINCT  p.ProductName
FROM dbo.Products p join dbo.[Order Details] od on p.ProductID = od.ProductID
					join dbo.Orders o on od.OrderID = o.OrderID
WHERE o.OrderDate >=  DATEADD(YEAR,-27, GETDATE())
ORDER BY p.ProductName

--15. List top 5 locations (Zip Code) where the products sold most.
SELECT  Top(5) o.ShipPostalCode
FROM dbo.Products p join dbo.[Order Details] od on p.ProductID = od.ProductID
					join dbo.orders o on od.OrderId = o.OrderID
Group by o.ShipPostalCode 
ORDER BY sum(od.Quantity) desc

--16. List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT TOP(5) o.ShipPostalCode
FROM dbo.Products p join dbo.[Order Details] od on p.ProductID = od.ProductID
					join dbo.Orders o on o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(year, -27, getdate())
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity) desc

--17. List all city names and number of customers in that city.     
SELECT c.City as CITYNAME, COUNT(c.CustomerID) AS NUMBER_Customers
FROM dbo.Customers c
GROUP BY c.City

--18. List city names which have more than 2 customers, and number of customers in that city
SELECT c.City, Count(c.customerID)AS NUMBER_Customers
FROM dbo.Customers c 
GROUP BY c.City
HAVING Count(c.customerID) >2

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.ContactName AS CustomerName
FROM dbo.Customers c join dbo.Orders o on c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '1/1/98'

--20. List the names of all customers with most recent order dates
SELECT c.ContactName AS CustomerName, o.OrderDate 
FROM dbo.Customers c join dbo.Orders o on c.CustomerID = o.CustomerID
Where o.OrderDate = (
 select MAX(OrderDate) from Orders
)

--21. Display the names of all customers along with the count of products they bought
SELECT c.ContactName AS CustomerName, ISNULL(SUM(od.Quantity), 0) as ProductCount
FROM dbo.Customers c Left join dbo.Orders o on c.CustomerID = o.CustomerID
					 LEFT join dbo.[Order Details] od on o.OrderID = od.OrderID
GROUP BY c.ContactName
Order by ProductCount desc

--22. Display the customer ids who bought more than 100 Products with count of products.
SELECT o.CustomerID
FROM dbo.Orders o LEFT join dbo.[Order Details] od on o.OrderID = od.OrderID					 
GROUP BY o.CustomerID
HAVING ISNULL(SUM(od.Quantity),0) > 100
ORDER BY ISNULL(SUM(od.Quantity),0)

--23. List all of the possible ways that suppliers can ship their products. Display the results as below Supplier Company Name 
select Distinct su.CompanyName as   'Supplier Company Name', sh.CompanyName as 'Shipping Company Name'
FROM dbo.Products p join dbo.Suppliers su on p.SupplierID = su.SupplierID					
					join dbo.[Order Details] od on p.ProductID = od.ProductID
					join dbo.Orders o on od.OrderID = o.OrderID
					join dbo.Shippers sh on sh.ShipperID = o.ShipVia
ORDER BY su.CompanyName

--24. Display the products order each day. Show Order date and Product Name.
SELECT P.ProductName, O.OrderDate
FROM dbo.Products p join dbo.[Order Details] od on p.ProductID = od.ProductID
					join dbo.Orders o on od.OrderID = o.OrderID
ORDER BY O.OrderDate

--25. Displays pairs of employees who have the same job title.
SELECT 
    e1.FirstName + ' ' + e1.LastName AS Employee1,
    e2.FirstName + ' ' + e2.LastName AS Employee2,
    e1.Title
FROM Employees e1
JOIN Employees e2 ON 
    e1.Title = e2.Title AND 
    e1.EmployeeID < e2.EmployeeID
ORDER BY e1.Title, Employee1, Employee2;

--26. Display all the Managers who have more than 2 employees reporting to them.
SELECT 
	e2.EmployeeID as 'ManagerID',
    e2.FirstName + ' ' + e2.LastName AS ManagerName,
    COUNT( e2.EmployeeID) AS 'ReportCount'
FROM Employees e1 JOIN Employees e2 ON  e1.ReportsTo = e2.EmployeeID
Group by  e2.EmployeeID,  e2.FirstName,e2.LastName
HAVING COUNT( e2.EmployeeID) >2

--27. Display the customers and suppliers by city. The results should have the following columns City Name Contact Name, Type (Customer or Supplier)
SELECT 
    City, 
    CompanyName AS Name, 
    ContactName, 
    'Customer' AS Type 
FROM Customers

UNION ALL

SELECT 
    City, 
    CompanyName AS Name, 
    ContactName, 
    'Supplier' AS Type 
FROM Suppliers;