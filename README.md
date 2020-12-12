# CarScrapper

TLDR: Car Data Scrapping

Current Status:

1. Python process is built to scrap through a list of Make/Model/Year of cars.
2. Sql Server is set up to hold data inserted from python process.
   a. Working on getting the duplicate / update on VINs finalized.

Attainable Goals:

1. Scrap Car Data
   a. I am scrapping data from Edmunds on an assortment of makes, models & years.
2. Clean the Data
   a. The data will then be cleaned into SQL Server.
   b. I will need to be able to handle duplicates / update in VINs
3. Analyze the Datas
   a. I want to analyze depretiation by year and trim.
   b. I want to rank cars by the best buys, flag bad buys.
4. Make a Website for Scrapped Data / Summary
   a. I want to make a website that someone can look up their car or by make/model.
   b. I would possibly suggest the best buys and direct them to Edmunds.
   i. I need to look into the legality of hosting Edmunds Data :).

Ideal future goals:

1. Build process to periodically lookup previously VIN's directly to update info / mark sold / reduced price.
2. Use the Photos of the car for modelling outliers / wrecked cars / trim levels of non-listed.
3. Move this to Azure or AWS for practice with those
4. Create Kaftka or API for anyone to collect the cleaned data i have collected.
