USE JP_Keyboard



-- Display Product that sells more than average
SELECT p.ProductName, TotalPurchase FROM (
	SELECT [avg]=AVG(TotalPurchase) FROM (
		SELECT pr.ProductId, [TotalPurchase]=COUNT(pr.ProductId) FROM ProductTransactionDetail ptd
		JOIN Product pr ON pr.ProductId = ptd.ProductId
		GROUP BY pr.ProductId
	) AS pp
	JOIN Product p ON pp.ProductId = p.ProductId
) AS pavg,Product p
JOIN (
SELECT p.ProductId, [TotalPurchase]=COUNT(p.ProductId) FROM ProductTransactionDetail ptd
JOIN Product p ON p.ProductId = ptd.ProductId
GROUP BY p.ProductId
) AS pp ON  p.ProductId=pp.ProductId
WHERE TotalPurchase>[avg]



-- List all products bought by CC and avg product price of the products bought by CC
SELECT  
[ProductNo]='Product'+CAST(p.ProductId AS VARCHAR),
ProductName, 
ProductDescription,
[TotalQtyBought]=SUM(Qty)
FROM  Customer c
JOIN ProductTransaction pt ON c.CustomerId=pt.CustomerId
JOIN ProductTransactionDetail ptd ON ptd.ProductTransactionId=pt.ProductTransactionId 
JOIN Product p ON p.ProductId=ptd.ProductId
WHERE c.CustomerName = 'Clarissa Chuardi'
GROUP BY p.ProductId, p.ProductName, p.ProductDescription





--List all customer that ever bought any 'gateron' switch, that have never bought any charry mx switch
SELECT CustomerName, [CustomerDOB]=CONVERT(VARCHAR,CustomerDOB,113), [CustomerGender]=LEFT(CustomerGender,1)
FROM Customer c
WHERE EXISTS (
	SELECT * FROM ProductTransaction pt
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId 
	JOIN Product p ON ptd.ProductId=p.ProductId
	WHERE pt.CustomerId=c.CustomerId AND p.ProductName LIKE '%gateron%'
)AND NOT EXISTS (
	SELECT * FROM ProductTransaction pt
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId 
		JOIN Product p ON ptd.ProductId=p.ProductId
	WHERE pt.CustomerId=c.CustomerId AND p.ProductName LIKE '%space65%'
)







-- Display Customer who never bought Kailh Box Dark Yellow and ever bought Keychron K8 
SELECT * FROM Customer c
WHERE NOT EXISTS(	
	SELECT * FROM ProductTransaction pt
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId
	JOIN Product p ON p.ProductId=ptd.ProductId
	WHERE pt.CustomerId=c.CustomerId AND 
  p.ProductName = 'Kailh Box Dark Yellow'
) AND EXISTS(	
	SELECT * FROM ProductTransaction pt
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId
	JOIN Product p ON p.ProductId=ptd.ProductId
	WHERE pt.CustomerId=c.CustomerId AND 
  p.ProductName LIKE 'Keychron K8'
)


-- Show list of technician and list of distinct service the technician has ever done
SELECT 
t.TechnicianName ,
 STUFF(
 (
SELECT 
DISTINCT ', '+ServiceName
FROM ServiceTransaction st 
JOIN ServiceTransactionDetail std ON st.ServiceTransactionId=std.ServiceTransactionId
JOIN [Service] s ON std.ServiceId = s.ServiceId
WHERE st.TechnicianId=t.TechnicianId
for xml path(''), type).value('(./text())[1]','varchar(1000)'), 1, 2, '') as [Services Done]
FROM 
Technician t
ORDER BY t.TechnicianName


-- Show list of products which is classified in produt type
SELECT 
pt.ProductTypeName,
 STUFF(
 (
SELECT 
', '+p.ProductName
FROM Product p 
WHERE pt.ProductTypeId=p.ProductTypeId
ORDER BY p.ProductName
for xml path(''), type).value('(./text())[1]','varchar(MAX)'), 1, 2, '') as [Products]
FROM 
ProductType pt


--show list of customer and list of distinct product the customer where product is a keyboard 
SELECT 
c.CustomerName ,
 STUFF((
SELECT 
DISTINCT ', '+ProductName
FROM ProductTransaction pt 
JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId
JOIN [Product] p ON ptd.ProductId = p.ProductId
JOIN ProductType pty ON pty.ProductTypeId=p.ProductTypeId
WHERE pt.CustomerId=c.CustomerId 
AND pty.ProductTypeName = 'keyboard' 
for xml path(''), type).value('(./text())[1]','varchar(1000)'), 1, 2, '') as [Keyboards Bought]
FROM Customer c 



--  show staff, total transaction the staff made and total revenue the staff made in this year for staff who made more than 1 transaction, order by total revenue descending
SELECT s.StaffId,s.StaffName, TotalTransaction, SUM(p.ProductPrice*Qty) AS TotalRevenue
FROM 
(
    SELECT s.StaffId, COUNT(s.StaffId) AS TotalTransaction FROM staff s
    JOIN ProductTransaction pt ON s.StaffId=pt.StaffId
    WHERE YEAR(pt.ProductTransactionDate)=YEAR(GETDATE())
    GROUP BY s.StaffId
) AS at
JOIN staff s ON s.StaffId=at.StaffId
JOIN ProductTransaction pt ON s.StaffId=pt.StaffId
JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId
JOIN product p ON p.ProductId=ptd.ProductId
WHERE YEAR(pt.ProductTransactionDate)=YEAR(GETDATE()) AND TotalTransaction>1
GROUP BY s.StaffId, s.StaffName,TotalTransaction
ORDER BY TotalRevenue DESC








--Display Staff's Nickname (obtained from first 2 characters of StaffName and staff id), and Name (obtained by taking character after the first space until character before second space in StaffName) for every staff whose name contains at least 3 words and hasn’t served female customer. (left, cast, substring, charindex, len, not exists, in,not like, like)
SELECT * FROM Staff
SELECT [NickName] = LEFT(StaffName, 2)+'-'+CAST(StaffId AS VARCHAR) , 
MiddleName=Substring(Substring(StaffName,CHARINDEX(' ',StaffName)+1,LEN(StaffName)),0,
CHARINDEX(' ',Substring(StaffName,CHARINDEX(' ',StaffName)+1,LEN(StaffName))))
FROM Staff s
WHERE NOT EXISTS(
	SELECT * FROM ProductTransaction ps
	WHERE ps.StaffId = s.StaffId
	AND CustomerId in(
		SELECT CustomerId 
		FROM Customer
		WHERE CustomerGender LIKE 'Female'
	)
) AND StaffName LIKE '% % %'



--Display customerlastname total revenue from a customer 



SELECT c.CustomerId, [LastName]=REVERSE(SUBSTRING(REVERSE(CustomerName),0,CHARINDEX(' ',REVERSE(CustomerName))+1)), ISNULL(pr.TotalRevenue,0)+ISNULL(sr.TotalRevenue,0) AS [TotalRevenue] 
FROM Customer c
LEFT JOIN (
	SELECT CustomerId, [TotalRevenue]=SUM(p.ProductPrice*Qty) FROM 
	ProductTransaction pt 
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId
	JOIN Product p ON p.ProductId=ptd.ProductId
	GROUP BY CustomerId
)AS pr ON c.CustomerId = pr.CustomerId
LEFT JOIN (
	SELECT CustomerId, [TotalRevenue]=SUM(p.ServiceBasePrice*Qty) FROM ServiceTransaction pt 
	JOIN ServiceTransactionDetail ptd ON pt.ServiceTransactionId=ptd.ServiceTransactionId
	JOIN Service p ON p.ServiceId=ptd.ServiceId
	GROUP BY CustomerId
)AS sr ON c.CustomerId=sr.CustomerId



-- show technicianName (obtained from technician's first name), TechnicianRoundedAge(Obtained from year difference between technician dob and the date now ) notes: if the technician only have 1 word in his/her name, make sure it still appears
SELECT [TechnicianName]=
LEFT(TechnicianName,ISNULL(NULLIF(CHARINDEX(' ',TechnicianName), 0), LEN(TechnicianName))),
[TechnicianAge]=CASE
	WHEN (MONTH(GETDATE())<MONTH(TechnicianDOB)) THEN CAST(DATEDIFF(YEAR,t.TechnicianDOB,GETDATE())-1 AS VARCHAR)+' year(s) old'
	WHEN (MONTH(GETDATE())=MONTH(TechnicianDOB) AND DAY(GETDATE())<DAY(TechnicianDOB)) THEN CAST(DATEDIFF(YEAR,t.TechnicianDOB,GETDATE())-1 AS VARCHAR)+' year(s) old'
	ELSE CAST(DATEDIFF(YEAR,t.TechnicianDOB,GETDATE()) AS VARCHAR)+' year(s) old'
END 
FROM Technician t
WHERE t.TechnicianGender='Male' AND DATEDIFF(YEAR,t.TechnicianDOB,GETDATE()) < 25




-- Show customer who never made any service transaction, technician who never made any service transaction, Customer Who Never Made any ProductTransaction and staff who never made any product transaction 

SELECT (SELECT [Name]=Customername
	FROM Customer c
	LEFT JOIN ServiceTransaction st ON st.CustomerId=c.CustomerId
	GROUP BY c.CustomerId, CustomerName
	HAVING COUNT(st.ServiceTransactionId)=0) AS CustomerWhoeNeverMadeServiceTransaction,
	(	SELECT Technicianname
	FROM Technician c
	LEFT JOIN ServiceTransaction st ON st.TechnicianId=c.TechnicianId
	GROUP BY c.TechnicianId, TechnicianName
	HAVING COUNT(st.ServiceTransactionId)=0) AS TechnicianWhoNeverMadeServiceTransaction,
	(SELECT Customername
	FROM Customer c
	LEFT JOIN ProductTransaction st ON st.CustomerId=c.CustomerId
	GROUP BY c.CustomerId, CustomerName
	HAVING COUNT(st.ProductTransactionId)=0) AS CustomerWhoNeverMadeProductTransaction,
	(SELECT Staffname
	FROM Staff c
	LEFT JOIN ProductTransaction st ON st.StaffId=c.StaffId
	GROUP BY c.StaffId, StaffName
	HAVING COUNT(st.ProductTransactionId)=0) AS StaffWhoNeverMadeProductTransaction
	
	


-- List all customer with all it's  (Pivot)


SELECT * 
FROM
(
	SELECT CustomerName, a.AddressId FROM Customer c 
	JOIN [Address] a ON c.CustomerId=a.CustomerId
) AS ca
PIVOT
(	COUNT(AddressId) FOR CustomerName 
	IN (
		[Vincent Benedict],
		[Brandon Julio Thenaro],
		[Clarissa Chuardi],
		[Skolastika Gabriella Theresendia Prasetyo],
		[Johanes Peter Vincentius],
		[Lim Lionel Ritchie],
		[Stanley Dave Teherag],
		[Thaddeus Cleo]
	)) AS caPivot



-- pivot cari revenue setiap service yang ada 

SELECT 
*
FROM 
(
	SELECT ServiceName, [Revenue]=(ServiceBasePrice*Qty)+ServiceAdditionalPrice 
	FROM ServiceTransaction st
	JOIN ServiceTransactionDetail std ON st.ServiceTransactionId=std.ServiceTransactionId
	JOIN Service s ON s.ServiceId=std.ServiceTransactionId
) AS ServiceSourceTable
PIVOT
(	SUM(Revenue) FOR ServiceName
	IN (
		[Change Case],
		[Desolder],
		[Install Foam],
		[Solder],
		[Solder and desoldering],
		[Stabilizer Lubing],
		[Switch Film installation],
		[Switch Film installation and Lubing],
		[Switch Lubing]

	)) AS revenuePivot





-- cari revenue of all service and product transactions at october, november and december at 2020



SELECT * FROM 
(
	SELECT [Month]=DATENAME(MONTH,pt.ProductTransactionDate),[Revenue]=(p.ProductPrice*Qty)
	FROM ProductTransaction pt
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId = ptd.ProductTransactionId
	JOIN Product p ON p.ProductId=ptd.ProductTransactionId
	WHERE YEAR(pt.ProductTransactionDate)=2020 AND MONTH(pt.ProductTransactionDate) IN (10,11,12)
	UNION
	SELECT [Month]=DATENAME(MONTH,st.ServiceTransactionDate),[Revenue]=(ServiceBasePrice*Qty)+ServiceAdditionalPrice
	FROM ServiceTransaction st
	JOIN ServiceTransactionDetail std ON st.ServiceTransactionId=std.ServiceTransactionId  
	JOIN [Service] s ON s.ServiceId=std.ServiceId
	WHERE YEAR(st.ServiceTransactionDate)=2020 AND MONTH(st.ServiceTransactionDate) IN (10,11,12)
) AS RevenueTable
PIVOT
(	SUM([Revenue]) FOR [Month]
	IN (
		October
		,November
		,December
	)) AS revenuePivot


-- Generate customerProductTransactionreport in xml 

SELECT CustomerName,[TotalProductTransaction]=COUNT(c.CustomerId), [TotalMoneySpentOnProduct]=SUM(ProductPrice*Qty) FROM Customer c 
JOIN ProductTransaction pt ON pt.CustomerId=c.CustomerId
JOIN ProductTransactionDetail ptd on pt.ProductTransactionId=ptd.ProductTransactionId
JOIN Product p ON ptd.ProductId=p.ProductId
WHERE YEAR(pt.ProductTransactionDate)=2020
GROUP BY c.CustomerId,CustomerName
ORDER BY SUM(ProductPrice*Qty) DESC
FOR XML PATH ('ProductTransaction'),ROOT('CustomerProductTransactionReport')




USE JP_Keyboard
SELECT * FROM Customer
-- ambil dari json 

DECLARE @container VARCHAR(4000)
SELECT @container=BulkColumn
FROM OPENROWSET(BULK 'C:\Users\User\Documents\0. JP20-2\CaseMake\JP Keyboard\keyboard.json', SINGLE_CLOB)
AS T
SELECT 
[ProductName]= JSON_VALUE(@container,'$.ProductName'),
[ProductPrice]=JSON_VALUE(@container,'$.ProductPrice'),
[ProductStock]=JSON_VALUE(@container,'$.ProductStock'),
[ProductWeight]=JSON_VALUE(@container,'$.ProductWeight'),
[ProductDescription]=
JSON_VALUE(@container,'$.ProductName')+' '+JSON_VALUE(@container,'$.ProductType')+ 
' with '+JSON_VALUE(JSON_QUERY(@container,'$."Specifications"'),'$.Layout')+' layout that features '+
JSON_VALUE(JSON_QUERY(@container,'$."Specifications"'),'$.Features[0]')+', '+
JSON_VALUE(JSON_QUERY(@container,'$."Specifications"'),'$.Features[1]')+'and '+
JSON_VALUE(JSON_QUERY(@container,'$."Specifications"'),'$.Features[2]')+' and supports '+
JSON_VALUE(JSON_QUERY(@container,'$."Specifications"'),'$.Connections[0]')+' and '+
JSON_VALUE(JSON_QUERY(@container,'$."Specifications"'),'$.Connections[1]')+ ' Connection',
[ProductType]=JSON_VALUE(@container,'$.ProductType')





-- csv


CREATE TABLE #ArrivedKeyboardStock(
	ProductName VARCHAR(80) CHECK(LEN(ProductName)>0) NOT NULL,
	ProductPrice INT CHECK(ProductPrice>0) NOT NULL,  
	ProductStock INT NOT NULL,
	ProductWeight FLOAT NOT NULL,
	ProductDescription VARCHAR(300) NOT NULL
)
BULK INSERT #ArrivedKeyboardStock
FROM 'C:\Users\User\Documents\0. JP20-2\CaseMake\JP Keyboard\keyboard.csv'
WITH 
(
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='\n',
	TABLOCK
)



SELECT * FROM #ArrivedKeyboardStock
WHERE ProductDescription NOT LIKE '%membrane%'





SELECT * FROM ProductType


-- Display Technician who ever made a transaction with johanes peter vincentius but never made transaction with brandon julio thenaro

SELECT t.TechnicianName FROM ServiceTransaction st 
JOIN Customer c ON c.CustomerId=st.CustomerId
JOIN Technician t ON t.TechnicianId=st.TechnicianId
WHERE c.CustomerName='Johanes Peter Vincentius'
AND YEAR(st.ServiceTransactionDate)=2020 
EXCEPT
SELECT t.TechnicianName FROM ServiceTransaction st 
JOIN Customer c ON c.CustomerId=st.CustomerId
JOIN Technician t ON t.TechnicianId=st.TechnicianId
WHERE c.CustomerName='Brandon Julio Thenaro'
AND YEAR(st.ServiceTransactionDate)=2020








-- cari customer paling loyal cuk  sambil customer punya inisial deng dari email cari customer yang 3 kata namanya  (Left, charindex)
SELECT [MiddleName]=RIGHT(LEFT(CustomerName,CHARINDEX(' ',CustomerName,CHARINDEX(' ',CustomerName)+1)-1),
LEN(LEFT(CustomerName,CHARINDEX(' ',CustomerName,CHARINDEX(' ',CustomerName)+1)-1))-CHARINDEX(' ',CustomerName)), [Initial]=UPPER(LEFT(CustomerEmail, CHARINDEX('@',CustomerEmail)-1)) FROM Customer  c
JOIN ProductTransaction pt ON pt.CustomerId=c.CustomerId
WHERE YEAR(pt.ProductTransactionDate)=2021 AND CustomerName LIKE '% % %'
GROUP BY c.CustomerId, CustomerName, CustomerEmail
HAVING COUNT(ProductTransactionId) >3
INTERSECT
SELECT [MiddleName]=RIGHT(LEFT(CustomerName,CHARINDEX(' ',CustomerName,CHARINDEX(' ',CustomerName)+1)-1),
LEN(LEFT(CustomerName,CHARINDEX(' ',CustomerName,CHARINDEX(' ',CustomerName)+1)-1))-CHARINDEX(' ',CustomerName)), [Initial]=UPPER(LEFT(CustomerEmail, CHARINDEX('@',CustomerEmail)-1))  FROM Customer c 
JOIN ServiceTransaction st ON st.CustomerId=c.CustomerId
WHERE YEAR(st.ServiceTransactionDate)=2021 AND CustomerName LIKE '% % %'
GROUP BY c.CustomerId, CustomerName, CustomerEmail
HAVING COUNT(ServiceTransactionId)>3




SELECT * FROM CUstomer


-- display Customer yang beli product sama service sekaligus 
SELECT [Initial]=LEFT(CustomerName,1)+SUBSTRING(CustomerName,CHARINDEX(' ',CustomerName)+1,1), [TransactionDate]=CONVERT(VARCHAR, pt.ProductTransactionDate ,13) 
FROM Customer c 
JOIN ProductTransaction pt ON c.CustomerId=pt.CustomerId
INTERSECT 
SELECT [Initial]=LEFT(CustomerName,1)+SUBSTRING(CustomerName,CHARINDEX(' ',CustomerName)+1,1), [TransactionDate]=CONVERT(VARCHAR, st.ServiceTransactionDate ,13) 
FROM Customer c 
JOIN ServiceTransaction st ON c.CustomerId=st.CustomerId






--Display max product price, max service base price, min product price and min product base price
SELECT 'Maximum Product Price' AS [Title],MAX(p.ProductPrice) AS [Value] FROM ProductTransaction pt
JOIN ProductTransactionDetail ptt ON pt.ProductTransactionId=ptt.ProductTransactionId
JOIN Product p ON p.ProductId=ptt.ProductId
UNION
SELECT 'Maximum Service Base Price',MAX(s.ServiceBasePrice) FROM ServiceTransaction st
JOIN ServiceTransactionDetail stt ON st.ServiceTransactionId=stt.ServiceTransactionId
JOIN [Service] s ON s.ServiceId=stt.ServiceId
UNION
SELECT 'Minimum Product Price',MIN(p.ProductPrice) FROM ProductTransaction pt
JOIN ProductTransactionDetail ptt ON pt.ProductTransactionId=ptt.ProductTransactionId
JOIN Product p ON p.ProductId=ptt.ProductId
UNION
SELECT 'Minimum Service Base Price',MIN(s.ServiceBasePrice) FROM ServiceTransaction st
JOIN ServiceTransactionDetail stt ON st.ServiceTransactionId=stt.ServiceTransactionId
JOIN [Service] s ON s.ServiceId=stt.ServiceId

-- Show top 3 staff and top 3 technician who made the most transaction 


SELECT * FROM (
	SELECT TOP 3 s.StaffId AS ID,StaffName AS Name,[TransactionCount]=COUNT(s.StaffId) FROM Staff s 
	JOIN ProductTransaction pt ON pt.StaffId=s.StaffId
	JOIN Customer c ON pt.CustomerId=c.CustomerId
	WHERE YEAR(pt.ProductTransactionDate)=YEAR(GETDATE()) 
	GROUP BY s.StaffId, s.StaffName
	ORDER BY TransactionCount DESC
) AS topStaff
UNION
SELECT * FROM (
	SELECT TOP 3 s.TechnicianId,TechnicianName,[TransactionCount]=COUNT(s.TechnicianId) FROM Technician s 
	JOIN ServiceTransaction pt ON pt.TechnicianId=s.TechnicianId
	JOIN Customer c ON pt.CustomerId=c.CustomerId
	WHERE YEAR(pt.ServiceTransactionDate)=YEAR(GETDATE()) 
	GROUP BY s.TechnicianId, s.TechnicianName
	ORDER BY TransactionCount DESC
) AS topTechnician













-- Create cursor to show all table and all datatypes inside the table 
DECLARE @tableName VARCHAR(255), @tableSchema VARCHAR(255);
DECLARE tableCur CURSOR
FOR 
	SELECT t.TABLE_NAME, t.TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES t
OPEN tableCur
FETCH NEXT FROM tableCur
into @tableName, @tableSchema

WHILE @@FETCH_STATUS=0
BEGIN 
	
	PRINT @tableSchema+'.'+@tableName+'('
	
	
	DECLARE @columnName VARCHAR(255), @dataType VARCHAR(255)
	DECLARE columnCur CURSOR 
	FOR
		SELECT c.COLUMN_NAME,c.DATA_TYPE FROM 
		INFORMATION_SCHEMA.COLUMNS c 
		WHERE c.TABLE_NAME=@tableName AND c.TABLE_SCHEMA=@tableSchema

	OPEN columnCur 
	FETCH NEXT FROM columnCur
	INTO @columnName, @dataType

	WHILE @@FETCH_STATUS=0
	BEGIN 
		PRINT '   '+@columnName+' '+@dataType	
		FETCH NEXT FROM columnCur
		INTO @columnName, @dataType
	END
	CLOSE columnCur
	DEALLOCATE columnCur
	PRINT ')'
	FETCH NEXT FROM tableCur
	INTO @tableName, @tableSchema
END
CLOSE tableCur 
DEALLOCATE tableCur



-- Create cursor to retrieve first, last and some customer to buy a service in year 2021

DECLARE @customerName VARCHAR(255), @customerEmail VARCHAR(255), @customerGender VARCHAR(255)
DECLARE prodSkipCursor SCROLL CURSOR 
FOR
SELECT c.CustomerName, c.CustomerEmail, c.CustomerGender
FROM ServiceTransaction st 
JOIN Customer c ON st.CustomerId=c.CustomerId
WHERE YEAR(st.ServiceTransactionDate)=2021
ORDER BY st.ServiceTransactionDate
OPEN prodSkipCursor
FETCH FIRST FROM prodSkipCursor
INTO @customerName, @customerEmail,@customerGender
PRINT 'First Customer'
PRINT '=============='
PRINT 'Name   : '+@customerName
PRINT 'Email  : '+@customerEmail
PRINT 'Gender : '+@customerGender

FETCH LAST FROM prodSkipCursor
INTO @customerName, @customerEmail,@customerGender
PRINT 'Last Customer'
PRINT '=============='
PRINT 'Name   : '+@customerName
PRINT 'Email  : '+@customerEmail
PRINT 'Gender : '+@customerGender

FETCH ABSOLUTE 8 FROM prodSkipCursor
INTO @customerName, @customerEmail,@customerGender
PRINT 'Mid Customers'
WHILE @@FETCH_STATUS=0
BEGIN 
	PRINT '=============='
	PRINT 'Name   : '+@customerName
	PRINT 'Email  : '+@customerEmail
	PRINT 'Gender : '+@customerGender
	FETCH RELATIVE 8 FROM prodSkipCursor
	INTO @customerName, @customerEmail,@customerGender

END

CLOSE prodSkipCursor
DEALLOCATE prodSkipCursor











-- Create Stored Prochedure to get all table size
CREATE PROC PrintMasterTableSizes
AS BEGIN
	SELECT 
	[Product]=(SELECT [Product]=COUNT(ProductId)
	FROM Product), 
	[Staff]=(SELECT COUNT(StaffId)
	FROM Staff),
	[Service]=(SELECT COUNT(ServiceId)
	FROM [Service]),
	[Customer]=(SELECT COUNT(Customerid)
	FROM Customer),
	Technician=(SELECT COUNT(TechnicianId)
	FROM Technician)
END

GO
EXEC dbo.PrintMasterTableSizes;
GO

--Create Prochedure to show services purchased by customer 

CREATE PROC ShowServices @CustomerId VARCHAR(255)
AS 
BEGIN 
	DECLARE @CustomerName VARCHAR(255),@TotalPrice INT,@AvgPrice INT, @FavServiceName VARCHAR(255), @LastTransactionDate DATE;
	SELECT @CustomerName=CustomerName FROM Customer
	WHERE CustomerId=@customerId
	SELECT @TotalPrice=SUM((ServiceBasePrice * Qty)+ServiceAdditionalPrice)
	FROM ServiceTransaction pd, ServiceTransactionDetail ptd, [Service] p 
	WHERE	pd.ServiceTransactionId=ptd.ServiceTransactionId 
	AND ptd.ServiceId=p.ServiceId
	AND CustomerId=@CustomerId
	
	
	SELECT @AvgPrice=AVG((ServiceBasePrice * Qty)+ServiceAdditionalPrice)
	FROM ServiceTransaction pd, ServiceTransactionDetail ptd, [Service] p 
	WHERE	pd.ServiceTransactionId=ptd.ServiceTransactionId 
	AND ptd.ServiceId=p.ServiceId
	AND CustomerId=@CustomerId

	SELECT @LastTransactionDate=MAX(pd.ServiceTransactionDate)
	FROM ServiceTransaction pd 
	WHERE	CustomerId=@CustomerId

	SELECT TOP 1 @FavServiceName=ServiceName
	FROM ServiceTransaction pd, ServiceTransactionDetail ptd, [Service] p 
	WHERE	pd.ServiceTransactionId=ptd.ServiceTransactionId 
	AND ptd.ServiceId=p.ServiceId
	AND CustomerId=@CustomerId
	GROUP BY p.ServiceId, ServiceName
	ORDER BY COUNT(p.ServiceId)



	SELECT  ServiceName, COUNT(p.ServiceId)
	FROM ServiceTransaction pd, ServiceTransactionDetail ptd, [Service] p 
	WHERE	pd.ServiceTransactionId=ptd.ServiceTransactionId 
	AND ptd.ServiceId=p.ServiceId
	AND CustomerId=5
	GROUP BY p.ServiceId, ServiceName
	ORDER BY COUNT(p.ServiceId) DESC



	PRINT 'Customer Name                         : '+ @CustomerName
	PRINT 'Total Money Spend                     : ' + CAST(@TotalPrice AS VARCHAR)
	PRINT 'Average Money Spend                   : ' + CAST(@AvgPrice AS VARCHAR)
	PRINT 'Customer Most Ordered Service         : ' + CAST(@FavServiceName AS VARCHAR)
	PRINT 'Customer Last Service Transaction Date: ' + CONVERT(VARCHAR,@LastTransactionDate,113)

	DECLARE @ServiceName VARCHAR(255), @ServicePrice INT, @ServiceQty INT;
	DECLARE prodCursor CURSOR 
	FOR
	SELECT ServiceName, ServiceBasePrice, Qty
	FROM ServiceTransaction pd, ServiceTransactionDetail ptd, Service p 
	WHERE	pd.ServiceTransactionId=ptd.ServiceTransactionId 
	AND ptd.ServiceId=p.ServiceId
	AND CustomerId=@CustomerId
	OPEN prodCursor
	FETCH prodCursor
	INTO @ServiceName, @ServicePrice, @ServiceQty
	WHILE @@FETCH_STATUS=0
	BEGIN
		PRINT '========================================='
		PRINT 'Service Name  : '+ @ServiceName
		PRINT 'Service Base Price : '+ CAST(@ServicePrice AS VARCHAR)
		PRINT 'Service Qty   : '+ CAST(@ServiceQty AS VARCHAR)
		FETCH prodCursor
		INTO @ServiceName, @ServicePrice, @ServiceQty
	END
	CLOSE prodCursor
	DEALLOCATE prodCursor
END

GO
EXEC ShowServices 5

--Create Prochedure to show products purchased by customer 

CREATE PROC ShowProducts @CustomerId VARCHAR(255)
AS
BEGIN 
	DECLARE @CustomerName VARCHAR(255),@TotalPrice INT;

	SELECT @CustomerName=CustomerName FROM Customer
	WHERE CustomerId=@customerId
	   
	SELECT @TotalPrice=SUM(ProductPrice * Qty)
	FROM ProductTransaction pd, ProductTransactionDetail ptd, Product p 
	WHERE	pd.ProductTransactionId=ptd.ProductTransactionId 
	AND ptd.ProductId=p.ProductId
	AND CustomerId=@CustomerId
	PRINT 'Customer Name    : '+ @CustomerName
	PRINT 'Total Money Spend: ' + CAST(@TotalPrice AS VARCHAR)

	DECLARE @ProductName VARCHAR(255), @ProductPrice INT, @ProductQty INT;
	DECLARE prodCursor CURSOR 
	FOR
	SELECT ProductName, ProductPrice, Qty
	FROM ProductTransaction pd, ProductTransactionDetail ptd, Product p 
	WHERE	pd.ProductTransactionId=ptd.ProductTransactionId 
	AND ptd.ProductId=p.ProductId
	AND CustomerId=@CustomerId
	OPEN prodCursor
	FETCH prodCursor 
	INTO @ProductName, @ProductPrice, @ProductQty 
	WHILE @@FETCH_STATUS=0
	BEGIN
		PRINT '========================================='
		PRINT 'Product Name  : '+ @ProductName
		PRINT 'Product Price : '+ CAST(@ProductPrice AS VARCHAR)
		PRINT 'Product Qty   : '+ CAST(@ProductQty AS VARCHAR)
		FETCH prodCursor 
		INTO @ProductName, @ProductPrice, @ProductQty
		
	END
	CLOSE prodCursor
	DEALLOCATE prodCursor

END


EXEC dbo.ShowProducts 5




--Create Prochedure searchProduct to search product by keyword, sort by most relevant
GO
ALTER PROC searchProduct @searchString VARCHAR(255)
AS
	PRINT 'Search Results'
	PRINT '============================='
	DECLARE @id INT,@name VARCHAR(255), @price INT, @stock INT
	DECLARE prodCur CURSOR
	FOR
	 
		SELECT ProductId,ProductName,ProductPrice,ProductStock
		FROM Product p
		JOIN ProductType pt ON p.ProductTypeId=pt.ProductTypeId
		WHERE ProductName LIKE '%'+@searchString+'%'
		OR ProductTypeName LIKE '%'+@searchString+'%'
		OR ProductDescription LIKE '%'+@searchString+'%'
		ORDER BY  ProductName



	OPEN prodCur
	FETCH NEXT FROM prodCur 
	INTO @id,@name,@price,@stock
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		PRINT 'Product ID   :'+ CAST(@id AS VARCHAR)
		PRINT 'Product Name :'+ @name
		PRINT 'Product Price:'+ CAST(@price AS VARCHAR)
		PRINT '~'+
		CASE 
			WHEN @stock > 0 THEN 'Product is available for purchase'
			ELSE 'Product is currently not available for purchase, please wait for restock'
		END
		+'~'
		PRINT '============================='

		FETCH NEXT FROM prodCur 
		INTO @id,@name,@price,@stock
	END
	CLOSE prodCur
	DEALLOCATE prodCur

GO

EXEC searchProduct 'rgb'




--Create Prochedure to print square
CREATE PROC PrintSquare @size INT 
 AS
 BEGIN
	DECLARE @i INT, @t INT, @string VARCHAR(255);
	SET @i=0
	SET @t=0
	WHILE(@i<@size)
	BEGIN
		SET @string=''
		SET @t=0
		WHILE(@t<@size)
		BEGIN
			IF(@i=0 OR @t=0 OR @i=@size-1 OR @t=@size-1 OR @t=@i OR @t+@i=@size-1)SET @string+='#' 
			ELSE SET @string+=' ' 
		SET @t+=1
		END
		PRINT @string
		SET @i+=1
	END
 END


EXEC PrintSquare 10






-- Create trigger to show any if someone ordered a service 
GO
CREATE TRIGGER ServiceOrderAlert 
ON ServiceTransaction
AFTER INSERT 
AS 
	DECLARE @count INT 
	SELECT @count=COUNT(CustomerId) FROM ServiceTransaction st
	WHERE st.CustomerId=(SELECT CustomerId FROM inserted)

	DECLARE @name VARCHAR(255)
	SELECT @name=CustomerName FROM Customer 
	WHERE CustomerId=(SELECT CustomerId FROM inserted)

	PRINT @name+' has ordered '+CAST(@count AS VARCHAR)+'th service from JP Keyboard'
GO



BEGIN TRAN
INSERT INTO ServiceTransaction VALUES(5,3,GETDATE())
ROLLBACK







--Create trigger to show any data that is deleted/inserted/updated on table Product
GO
ALTER TRIGGER ProductTrigger
ON Product
AFTER INSERT,UPDATE,DELETE
AS
	DECLARE @name VARCHAR(255), @price INT, @stock INT, @weight INT, @desc VARCHAR(255), @type VARCHAR(255)
	IF(EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted))
	BEGIN 
		PRINT('A new product has been inserted')
		PRINT('================================')
		SELECT @name=ProductName, @price=ProductPrice, @stock=ProductStock, @weight=ProductWeight, @desc=ProductDescription,@type=ProductTypeName FROM inserted
		JOIN ProductType pt ON pt.ProductTypeId= inserted.ProductTypeId
		PRINT('Product Name       : '+@name)
		PRINT('Product Price      : '+CAST(@price AS VARCHAR))
		PRINT('Product Stock      : '+CAST(@stock AS VARCHAR))
		PRINT('Product Weight     : '+CAST(@weight AS VARCHAR))
		PRINT('Product Description: '+@desc)
		PRINT('Product Type       : '+@type)

	END
	ELSE IF(NOT EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted))
	BEGIN 
		PRINT('A product has been deleted')
		PRINT('==========================')
		SELECT @name=ProductName, @price=ProductPrice, @stock=ProductStock, @weight=ProductWeight, @desc=ProductDescription, @type=ProductTypeName FROM deleted
		JOIN ProductType pt ON pt.ProductTypeId= deleted.ProductTypeId 
		PRINT('Product Name       : '+@name)
		PRINT('Product Price      : '+CAST(@price AS VARCHAR))
		PRINT('Product Stock      : '+CAST(@stock AS VARCHAR))
		PRINT('Product Weight     : '+CAST(@weight AS VARCHAR))
		PRINT('Product Description: '+@desc)
		PRINT('Product Type       : '+@type)

	END
	ELSE 
	BEGIN
		PRINT('A product has been updated')
		PRINT('==========================')
		
		SELECT @name=ProductName, @price=ProductPrice, @stock=ProductStock, @weight=ProductWeight, @desc=ProductDescription, @type=ProductTypeName FROM inserted
		JOIN ProductType pt ON pt.ProductTypeId= inserted.ProductTypeId
		PRINT 'New Data'
		PRINT('Product Name       : '+@name)
		PRINT('Product Price      : '+CAST(@price AS VARCHAR))
		PRINT('Product Stock      : '+CAST(@stock AS VARCHAR))
		PRINT('Product Weight     : '+CAST(@weight AS VARCHAR))
		PRINT('Product Description: '+@desc)
		PRINT('Product Type       : '+@type)

		SELECT @name=ProductName, @price=ProductPrice, @stock=ProductStock, @weight=ProductWeight, @desc=ProductDescription, @type=ProductTypeName FROM deleted
		JOIN ProductType pt ON pt.ProductTypeId= deleted.ProductTypeId
		PRINT ''
		PRINT 'Old Data'
		PRINT('Product Name       : '+@name)
		PRINT('Product Price      : '+CAST(@price AS VARCHAR))
		PRINT('Product Stock      : '+CAST(@stock AS VARCHAR))
		PRINT('Product Weight     : '+CAST(@weight AS VARCHAR))
		PRINT('Product Description: '+@desc)
		PRINT('Product Type       : '+@type)
	END

BEGIN TRAN
INSERT INTO PRODUCT VALUES('testing', 92,2,212,'ini produk testing doang sih',2)
ROLLBACK

BEGIN TRAN 
DELETE PRODUCT WHERE ProductName='testing'
ROLLBACK

BEGIN TRAN 
UPDATE PRODUCT 
SET ProductName='testingupdated',
ProductPrice= 1234123,
ProductStock=432,
ProductWeight=11,
ProductDescription='ini produk testing testing'
WHERE ProductName='testing'

ROLLBACK

--Create trigger to prevent JP from being deleted changed
GO
CREATE TRIGGER PreventChange
ON Customer 
INSTEAD OF DELETE, UPDATE
AS
BEGIN
	DECLARE @deleteId INT;
	SELECT @deleteId=CustomerId
	FROM deleted
	IF(@deleteId!=5)DELETE FROM Customer WHERE CustomerId= @deleteId
	ELSE PRINT('You cannot delete/update Johanes Peter Vincentius from this database')
END

SELECT * FROM Customer
BEGIN TRAN 
DELETE FROM Customer WHERE CustomerId=5
ROLLBACK









--Create trigger to notify  
CREATE TRIGGER CustomerAddress
ON [Address]
FOR INSERT
AS	
	DECLARE @totalAddress INT, @CustomerName VARCHAR(255)
	
	SELECT @customerName=Customername
	FROM Customer 
	WHERE CustomerId=(SELECT CustomerId FROM inserted)
	SELECT @totalAddress= COUNT(AddressId)
	FROM [Address]
	WHERE CustomerId=(SELECT CustomerId FROM inserted)
	PRINT @customerName+' added a new address'
	PRINT @customerName+'''s total address: '+ CAST(@totalAddress AS VARCHAR)
	DECLARE @addressName VARCHAR(255), @streetName VARCHAR(255), @city VARCHAR(255), @country VARCHAR(255)
	SELECT @addressName=AddressName, @streetName=StreetName, @city=City , @country =Country FROM inserted
	PRINT 'Address Details'
	PRINT '=================='
	PRINT 'Address Name: '+@addressName
	PRINT 'Street Name : '+@streetName
	PRINT 'City        : '+@city
	PRINT 'Country     : '+@country


GO 
BEGIN TRAN
INSERT INTO Address VALUES(1,'Rumah','jalan makaliwe','jakarta','indonesia')
ROLLBACK


-- Create trigger if a producttransactiondetail is being deleted note that exProductTransactionDetail won't exists until the trigger is executed
CREATE TRIGGER TriggerStaffDelete
ON Staff
AFTER DELETE
AS
BEGIN
IF OBJECT_ID('resignedStaffs') is null
	SELECT * INTO resignedStaffs
	FROM deleted d
ELSE
	INSERT INTO resignedStaffs
	SELECT *
	FROM deleted d
END


BEGIN TRAN
DELETE FROM Staff WHERE StaffId=3
ROLLBACK
SELECT * FROM resignedStaffs




-- Create function to show revenue coming from every product type in the inputted yearr
GO
CREATE FUNCTION ProductTypeRevenue (@year INT)
RETURNS TABLE
AS 
RETURN(
	SELECT ProductTypeName,[TotalRevenue]=SUM(CAST(ProductPrice AS BIGINT)*Qty) FROM ProductTransaction pt
	JOIN ProductTransactionDetail ptd ON pt.ProductTransactionId=ptd.ProductTransactionId 
	JOIN Product p ON p.ProductId=ptd.ProductId
	JOIN ProductType pty ON pty.ProductTypeId=p.ProductTypeId
	WHERE YEAR(pt.ProductTransactionDate)=@year
	GROUP BY pty.ProductTypeId, ProductTypeName
); 
GO
SELECT * FROM dbo.ProductTypeRevenue(2021)



-- Create function to count factorial
GO
CREATE FUNCTION Factorial (@base INT )
RETURNS INT 
AS 
BEGIN 
	IF(@base<=1)
	BEGIN
		RETURN 1
	END
	RETURN @base * dbo.Factorial(@base-1)
END
GO 
SELECT dbo.Factorial(10)

        
-- Create function to select a random product based on it's type
GO
CREATE FUNCTION SelectRandomItem (@ProductTypeId INT, @RandomInt FLOAT) 
RETURNS TABLE 
AS
	RETURN 
	(
		SELECT ProductId, ProductName,ProductPrice, ProductStock,ProductWeight,ProductDescription 
		FROM 
		(SELECT [Row]=ROW_NUMBER() OVER (ORDER BY ProductName),* 
		FROM Product p
		WHERE p.ProductTypeId=@ProductTypeId) AS pp
		WHERE pp.Row=CAST(@RandomInt*((SELECT COUNT(ProductId) FROM Product pt WHERE ProductTypeId=@ProductTypeId))+1 AS INT)
	);

GO

SELECT * FROM dbo.SelectRandomItem(1,RAND())

USE JP_Keyboard
SELECT * FROM Product p
JOIN ProductType pt ON p.ProductTypeId=pt.ProductTypeId







-- Create function to calculate PRICE
GO
CREATE TYPE ScannedProductsTable AS TABLE(ProductId INT, qty INT);
GO

CREATE FUNCTION CalculateTotalPrice (@itemList ScannedProductsTable READONLY)
RETURNS INT 
AS 
	BEGIN
		DECLARE @totalPrice INT
		SELECT @totalPrice=SUM(qty*p.ProductPrice) 
		FROM @itemList i
		JOIN Product p ON p.ProductId=i.ProductId

		RETURN @totalPrice
	END

GO


DECLARE @prodTable AS ScannedProductsTable
INSERT INTO @prodTable 
VALUES(2,4),(5,10)
SELECT dbo.CalculateTotalPrice(@prodTable)






-- Create function play button
CREATE FUNCTION GetPlayButton(@size INT)
RETURNS @specialSquareTable TABLE(content VARCHAR(255))
AS 
BEGIN 
	IF(@size>255)
	BEGIN
		INSERT INTO @specialSquareTable VALUES('Size may not be larger then 255')
		RETURN 
	END
	DECLARE @i INT;
	DECLARE @t INT;
	SET @i=0 
	SET @t=0
	DECLARE @contentString VARCHAR(255);
	SET @contentString=''
	WHILE(@i<@size)
	BEGIN
		SET @contentString=''
		WHILE(@t<@size)
		BEGIN 
					IF(@i>=@t)SET @contentString+='*'
					ELSE SET @contentString+=' '
					SET @t+=1
		END
  		INSERT INTO @specialSquareTable VALUES (@contentString)
		SET @i+=1
		SET @t=0		
	END
	SET @i=0
	SET @contentString=''

	WHILE(@i<=@size) 
	BEGIN
		SET @i+=1
		SET @contentString+='*'
	END

  INSERT INTO @specialSquareTable VALUES (@contentString) 
	SET @i=0 
	SET @t=@size-1

	WHILE(@i<@size)
	BEGIN
		SET @contentString=''
		WHILE(@t>=0)
		BEGIN 
					IF(@t>=@i)SET @contentString+='*'
					ELSE SET @contentString+=' '
					SET @t-=1
		END
  		INSERT INTO @specialSquareTable VALUES (@contentString)
		SET @i+=1
		SET @t=@size-1		
	END
	RETURN 
END


SELECT * FROM dbo.GetPlayButton(300)








--Create cursor to drop all sp and trigger



SELECT name FROM sys.procedures

declare @name varchar(100), @type varchar(50)
declare dropCur cursor
for 
	select name, [type] = 'proc' from sys.procedures
	union
	select name, [type] = 'trigger' from sys.triggers
open dropCur
fetch next from dropCur
into @name, @type
while @@FETCH_STATUS = 0
begin
	exec('drop ' + @type + ' ' + @name)
	fetch next from dropCur
	into @name, @type
end
close dropCur
deallocate dropCur















