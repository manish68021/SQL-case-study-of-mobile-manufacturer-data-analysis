--SQL Advance Case Study


--Q1--BEGIN 
SELECT DISTINCT DL.State
FROM FACT_TRANSACTIONS FT
JOIN DIM_CUSTOMER as DC
ON FT.IDCustomer = DC.IDCustomer
JOIN DIM_LOCATION as DL 
ON FT.IDLocation = DL.IDLocation
JOIN DIM_DATE as DD 
ON FT.Date = DD.DATE
WHERE DD.YEAR >= 2005;

--Q1--END

--Q2--BEGIN
SELECT DL.[State],SUM(FT.Quantity) AS TotalSamsungPhones
FROM FACT_TRANSACTIONS FT
JOIN DIM_MODEL as DM 
ON FT.IDModel = DM.IDModel
JOIN DIM_MANUFACTURER MF 
ON DM.IDManufacturer = MF.IDManufacturer
JOIN DIM_CUSTOMER C 
ON FT.IDCustomer = C.IDCustomer
JOIN DIM_LOCATION as DL 
ON FT.IDLocation = DL.IDLocation
WHERE MF.Manufacturer_Name = 'Samsung'
GROUP BY DL.State
ORDER BY TotalSamsungPhones DESC;



--Q2--END

--Q3--BEGIN      
SELECT DM.Model_Name,DL.ZipCode, DL.[State], COUNT(*) AS NumberOfTransactions
FROM FACT_TRANSACTIONS as FT
JOIN  DIM_MODEL as DM 
ON FT.IDModel = DM.IDModel
JOIN DIM_LOCATION as DL 
ON FT.IDLocation = DL.IDLocation
GROUP BY DM.Model_Name, DL.ZipCode, DL.State
ORDER BY  DL.State, DL.ZipCode, DM.Model_Name;
	

--Q3--END

--Q4--BEGIN
SELECT TOP 1 Model_Name, Unit_price
FROM DIM_MODEL
ORDER BY Unit_price ASC;


--Q4--END

--Q5--BEGIN

SELECT DM.IDModel, DM.Model_Name, M.Manufacturer_Name, AVG(DM.Unit_price) as AveragePrice
FROM DIM_MODEL DM
 JOIN DIM_MANUFACTURER as M 
 ON DM.IDManufacturer = M.IDManufacturer
WHERE M.IDManufacturer 
IN 
( SELECT TOP 5 DM2.IDManufacturer 
FROM FACT_TRANSACTIONS FT 
JOIN DIM_MODEL as DM2 
ON FT.IDModel = DM2.IDModel
GROUP BY DM2.IDManufacturer
ORDER BY SUM(FT.Quantity) DESC )
GROUP BY DM.IDModel, DM.Model_Name, M.Manufacturer_Name
ORDER BY AveragePrice;


--Q5--END

--Q6--BEGIN
SELECT  DC.Customer_Name, AVG(FT.TotalPrice) as AverageAmountSpent
FROM  FACT_TRANSACTIONS as FT
JOIN  DIM_CUSTOMER as DC
ON FT.IDCustomer = DC.IDCustomer
JOIN  DIM_DATE as DD 
ON FT.Date = DD.DATE
WHERE DD.YEAR = 2009
GROUP BY  DC.Customer_Name
HAVING AVG(FT.TotalPrice) > 500;


--Q6--END
	
--Q7--BEGIN  
SELECT IDModel
FROM ( SELECT  IDModel,YEAR(Date) AS Year, RANK() OVER (PARTITION BY YEAR(Date) ORDER BY SUM(Quantity) DESC) AS QuantityRank 
      FROM  FACT_TRANSACTIONS
      WHERE  YEAR(Date) IN (2008, 2009, 2010)
      GROUP BY  IDModel, YEAR(Date)) RankedModels
WHERE QuantityRank <= 5
GROUP BY IDModel
HAVING COUNT(DISTINCT Year) = 3;

	

--Q7--END	
--Q8--BEGIN
WITH RankedSales AS ( SELECT DM.IDManufacturer, DD.YEAR, SUM(FT.TotalPrice) AS TotalSales,
        RANK() OVER (PARTITION BY d.YEAR ORDER BY SUM(t.TotalPrice) DESC) AS SalesRank
        FROM FACT_TRANSACTIONS as FT
        JOIN DIM_MODEL as DM
		ON FT.IDModel = DM.IDModel
        JOIN DIM_DATE as DD
		ON FT.Date = DD.DATE
        WHERE DD.YEAR IN (2009, 2010)
        GROUP BY DM.IDManufacturer, DD.YEAR)
SELECT RS.YEAR,  DMA.Manufacturer_Name, RS.TotalSales
FROM RankedSales as RS
JOIN DIM_MANUFACTURER as DMA 
ON RS.IDManufacturer = DMA.IDManufacturer
WHERE RS.SalesRank = 2;



--Q8--END
--Q9--BEGIN
SELECT DISTINCT M.Manufacturer_Name
FROM DIM_MANUFACTURER as M
JOIN DIM_MODEL MD 
ON M.IDManufacturer = MD.IDManufacturer

LEFT JOIN FACT_TRANSACTIONS FT2010 

ON MD.IDModel = FT2010.IDModel

LEFT JOIN DIM_DATE D2010

ON FT2010.Date = D2010.[DATE] AND D2010.[YEAR] = 2010

LEFT JOIN FACT_TRANSACTIONS FT2009

ON MD.IDModel = FT2009.IDModel

LEFT JOIN DIM_DATE D2009 

ON FT2009.Date = D2009.[DATE] 

AND D2009.[YEAR] = 2009
WHERE D2010.[YEAR] = 2010 
AND D2009.[YEAR] IS NULL;


--Q9--END

--Q10--BEGIN

select * , ((avg_price - lag_price)/lag_price) as percentage_change from (
select * , lag(avg_price,1) over(partition by idcustomer order by year) as lag_price ( 

select Idcustomer ,year(date) as year , avg(totalprice) as avg_price ,sum(quantity) as qty from FACT_TRANSACTIONS
where  Idcustomer in (select top 10 idcustomer from FACT_TRANSACTIONS
                       group by IDCustomer
                       order by sum(totalprice) desc )
group by Idcustomer , year(date) 
) as A 
) as B


--Q10--END
	