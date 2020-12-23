# Slowly_Changing_Dimention_Type_2_SQL_Server_SCD2
Example of a Slowly Changing Dimention Type 2 with the AdventureWorksLT2019 Tables examples

The proyect is an example of a Data Warehouse with clenase and core area. The source table is the SalesLT.Address of the adventureWorksLT2019. In the cleanse Table are 3 neu columns Hashkey_BK, HashKey_Data, Source. The column Hashkey_BK is a Hashkey from the Business Key in this case the Business Column is AddressID. The hashkey data come from the other values.

in The first skript you will find the creation of the tables cleanse and core and the dummy values for the core table
in The second skript is the Stored Procedures for the SCD2
in the third script you will find the insert of the values in the cleanse area and the execution of the SCD2 for the core
