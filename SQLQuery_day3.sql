USE Northwind
GO

--1. List all cities that have both Employees and Customers.
SELECT DISTINCT e.City
FROM dbo.Employees e join dbo.Customers c on e.City = c.City

--2. List all cities that have Customers but no Employee.
--a.Use sub-query
--b. Do not use sub-query
SELECT DISTINCT c.City
FROM dbo.Customers c 
WHERE c.City not in (
SELECT Distinct e.city 
from dbo.Employees e
)

SELECT DISTINCT c.City
FROM dbo.Customers c LEFT JOIN dbo.Employees e on c.City = e.City
WHERE e.EmployeeID is Null

--3. List all products and their total order quantities throughout all orders.
Select p.ProductName, ISNULL(SUM(od.Quantity),0) AS Total
FROM dbo.Products p left join dbo.[Order Details] od on p.ProductID = od.ProductID
GROUP BY P.ProductName
ORDER BY Total DESC

--4. List all Customer Cities and total products ordered by that city.
SELECT c.City, ISNULL(SUM(od.Quantity),0) AS TOTALPRODUCT
FROM dbo.Customers c Left Join dbo.Orders o on c.CustomerID = o.CustomerID
					 LEFT JOIN dbo.[Order Details] od on o.OrderID = od.OrderID
GROUP BY c.City
ORDER BY TOTALPRODUCT

--5. List all Customer Cities that have at least two customers.
SELECT c.City
FROM dbo.Customers c 
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2

--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT DISTINCT c.City
FROM dbo.Customers c left join dbo.Orders o on c.CustomerID = o.CustomerID
					 left join dbo.[Order Details] od on o.OrderID = od.OrderID
GROUP by c.City
HAVING ISNULL(COUNT(od.ProductID),0) >=2

--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.ContactName,c.City as 'Customer City', o.ShipCity as 'Ship City'
FROM dbo.Customers c join dbo.Orders o on c.CustomerID = o.CustomerID
WHERE C.City <> o.ShipCity	

--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
WITH ProductCityQuantity AS (
    SELECT 
        od.ProductID,
        c.City,
        SUM(od.Quantity) AS Qty,
        ROW_NUMBER() OVER(PARTITION BY od.ProductID ORDER BY SUM(od.Quantity) DESC) AS rn
    FROM dbo.[Order Details] od
    JOIN dbo.Orders o ON od.OrderID = o.OrderID
    JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
    GROUP BY od.ProductID, c.City
),
TopCities AS (
    SELECT ProductID, City AS TopCity
    FROM ProductCityQuantity
    WHERE rn = 1
),
TopProducts AS (
    SELECT 
        TOP 5 od.ProductID,
        p.ProductName,
        AVG(od.UnitPrice) AS AvgPrice,
        SUM(od.Quantity) AS TotalSold
    FROM dbo.[Order Details] od
    JOIN dbo.Products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID, p.ProductName
    ORDER BY TotalSold DESC
)
SELECT 
    tp.ProductName,
    tp.AvgPrice,
    tc.TopCity
FROM TopProducts tp
JOIN TopCities tc ON tp.ProductID = tc.ProductID;

--9. List all cities that have never ordered something but we have employees there.
--a. Use sub-query
--b. Do not use sub-query
SELECT e.City
FROM dbo.Employees e
WHERE e.City not in
(
SELECT o.ShipCity
FROM dbo.Customers c inner join dbo.Orders o on c.CustomerID = o.CustomerID
)

SELECT DISTINCT e.City
FROM dbo.Employees e left join dbo.Customers c on e.City = c.City
					 left join dbo.Orders o on o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)


--11. How do you remove the duplicates record of a table?
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY e.FirstName, e.Homephone ORDER BY e.EmployeeID) AS rn
    FROM dbo.Employees e
)

DELETE FROM CTE
WHERE rn > 1
