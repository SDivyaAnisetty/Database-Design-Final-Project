#  *Tourism-Nova Scotia* Data Mart Analysis
A step-by-step process of design, creation and loading of a Data Mart based on Tourism Analysis-Nova Scotia
Nova Scotia is a popular getaway known for it's scenic beauty and calm pace of life. Being surrounded by water all around, it hosts vast greenery and picturesque locations starting from a world famous Cabot Trails, local wineries, cozy cottages etc.


This Data mart contains the Tourist data starting from 2006 to 2024. The source for this data is [Tourism Nova Scotia Visitation](https://data.novascotia.ca/Business-and-Industry/Tourism-Nova-Scotia-Visitation/n783-4gmh/data_preview) page from [Nova Scotia Government's Open Data Portal](https://data.novascotia.ca/)


The mart is created based on the [Star Schema Design](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/star-schema-olap-cube/) as outlined by [Ralph Kimball](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/)


# **Steps to Tourism-Nova Scotia Data Mart Creation**
MS SQL Server 2022 and the below DDL and DML commands (checked ones) are used to achieve this mart.
- DDL-Data Definition Language deals with defining and managing the structure of data.

    - [x] CREATE
    - [x] ALTER
    - [x] DROP

- DML - Data Manipulation Language deals with modifying and manipulation of data.

    - [x] INSERT
    - [ ] UPDATE
    - [ ] DELETE


Follow the instructions and explanations on the '[TourismAnalysis-NovaScotia_DDL_DML_Instructions.ipynb](./TourismAnalysis-NovaScotia_DDL_DML_Instructions.ipynb)' file


Access here for SQL File on [DDL](./DataFolder/Final_DDL_TourismNS.sql) statements


Access here for SQL File on [DML](./DataFolder/Final_DML_TourismNS.sql) statements


## ERD
The Entity Relationship diagram for *Tourism-Nova Scotia* Data mart is as below.

![ERD](./DataFolder/Tourism_NovaScotia.png)


