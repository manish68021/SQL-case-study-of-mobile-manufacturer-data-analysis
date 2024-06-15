# Data Warehouse Datasets

## Overview

This repository contains a set of SQL datasets used for data warehousing and business intelligence purposes. The datasets included are:

- DIM_CUSTOMER
- FACT_TRANSACTIONS
- DIM_DATE
- DIM_LOCATION
- DIM_MANUFACTURER
- DIM_MODEL

Each dataset is designed to represent a specific aspect of the business and is structured to facilitate efficient querying and reporting.

# Datasets Description

## DIM_CUSTOMER

The `DIM_CUSTOMER` table contains detailed information about customers. It typically includes fields such as:

- **CustomerID**: A unique identifier for each customer.
- **FirstName**: The first name of the customer.
- **LastName**: The last name of the customer.
- **Email**: The email address of the customer.
- **PhoneNumber**: The phone number of the customer.

### FACT_TRANSACTIONS

The `FACT_TRANSACTIONS` table records individual transactions and links to various dimension tables. It typically includes fields such as:

- **CustomerID**: Foreign key to the `DIM_CUSTOMER` table.
- **Date**: Foreign key to the `DIM_DATE` table.
- **LocationID**: Foreign key to the `DIM_LOCATION` table.
- **ModelID**: Foreign key to the `DIM_MODEL` table.
- **Quantity**: The number of items involved in the transaction.
- **Totalprice**: The total price for the transaction.

### DIM_DATE

The `DIM_DATE` table provides a detailed breakdown of dates and is used to facilitate time-based analyses. It typically includes fields such as:

- **Date**: The date in 'YYYY-MM-DD' format.
- **Month**: The month of the year.
- **Year**: The year.
- **Quarter**: The quarter of the year.

### DIM_LOCATION

The `DIM_LOCATION` table contains information about different locations where transactions take place. It typically includes fields such as:

- **LocationID**: A unique identifier for each location.
- **City**: The city where the location is situated.
- **State**: The state where the location is situated.
- **Country**: The country where the location is situated.
- **zipCode**: The zip code of the location’s address.

### DIM_MANUFACTURER

The `DIM_MANUFACTURER` table contains information about manufacturers. It typically includes fields such as:

- **ManufacturerID**: A unique identifier for each manufacturer.
- **ManufacturerName**: The name of the manufacturer.

### DIM_MODEL

The `DIM_MODEL` table contains information about different models of products. It typically includes fields such as:

- **ModelID**: A unique identifier for each model.
- **ModelName**: The name of the model.
- **ManufacturerID**: Foreign key to the `DIM_MANUFACTURER` table.
- **unit_Price**: The price of the model.

## Usage

1. **Connecting to the Database**:
   - Ensure you have the necessary SQL client installed.
   - Connect to the database using your credentials.

2. **Running Queries**:
   - You can run SQL queries to retrieve, manipulate, and analyze the data.
   - Example query to fetch customer transactions:

     ```sql
     SELECT 
         c.CustomerID, 
         c.FirstName, 
         c.LastName, 
         t.TransactionID, 
         t.TotalAmount, 
         d.Date
     FROM 
         FACT_TRANSACTIONS t
     JOIN 
         DIM_CUSTOMER c ON t.CustomerID = c.CustomerID
     JOIN 
         DIM_DATE d ON t.DateID = d.DateID
     WHERE 
         c.CustomerID = 1;
     ```

3. **Creating Reports**:
   - Use SQL queries to generate reports and insights based on the data.
   - Example report to get total sales by month:

     ```sql
     SELECT 
         d.Month, 
         d.Year, 
         SUM(t.TotalAmount) AS TotalSales
     FROM 
         FACT_TRANSACTIONS t
     JOIN 
         DIM_DATE d ON t.DateID = d.DateID
     GROUP BY 
         d.Month, d.Year
     ORDER BY 
         d.Year, d.Month;
     ```

## Contributing

We welcome contributions to improve the datasets and their documentation. Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License.
