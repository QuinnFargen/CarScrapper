
# # # # Packages # # # #
import os
from time import sleep
import sys
from datetime import date
from bs4 import BeautifulSoup
import pandas as pd
import requests
from sqlconn import get_connLog, get_SqlInsert


class Scrapper:

    def __init__(self, drive, MakeModelYear):
        self.drive = drive
        self.connLog = get_connLog()
        self.SqlInsert = get_SqlInsert()
        self.MakeModelYear = MakeModelYear
        os.chdir(self.drive)
        self.loc = os.getcwd()

    def get_url(self, make, model, year, Loop):
        """
        Get url for cycle
        Different first pg from following 2+
        """
        urlbase = "https://www.edmunds.com/"
        pagenum = '?pagenumber='
        url = urlbase + make + '/' + model + '/' + year + '/'
        # PageNumbers for everything, first page no PageNum
        if Loop == 1:
            urlused = url
        else:
            urlused = url + pagenum + str(Loop)
        return urlused

    def write_drive(self, urltext, make, model, year, Loop):
        """
        Write entire car json to txt file on drive
        """
        dt = date.today().strftime("%Y_%m_%d")
        try:
            FileName = dt + '_' + make + '_' + model + \
                '_' + year + '_' + str(Loop) + ".txt"
            writeTxt = open(FileName, "w")
            writeTxt.write(urltext)
            writeTxt.close()
        except:
            pass

    def get_data(self, urlused, make, model, year, Loop):
        """
            Request Website
            Cook the Soup
            Pull Scrip Portion (Car Data)
            Write To Drive
            Seperate the Cars into a list
            Only Wnat Cars, Junk Start & End
        """
        header = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4040.128"}
        r = requests.get(urlused, headers=header, timeout=5)
        soup = BeautifulSoup(r.text, 'html.parser')
        scripttext = soup.find('script').getText()
        self.write_drive(scripttext, make, model, year, Loop)
        scriptlist = scripttext.split("},{")
        i = 0
        cars = []
        while i < len(scriptlist):
            # Want Data to be Vehicle, Make, Model, & Year
            if '"@type":"Vehicle"' in scriptlist[i] and make in scriptlist[i] and model in scriptlist[i] and year in scriptlist[i]:
                cars.append(scriptlist[i])
            i += 1
        return cars

    def log_data(self, cars, make, model, year, Loop):
        """
            Write json to Jason table in sql
            only if they are off MMY from cycle
        """
        # Write to Sql Server
        # print(make + '|' + model + '|' + year + '|' + str(Loop))
        cursor = self.connLog.cursor()
        Ord = 0
        while Ord < len(cars):
            Jason = [make + '|' + model + '|' + year + '|' + str(Loop) + '|' + str(
                Ord), '[{' + cars[Ord].replace("@", "").strip() + '}]', 1]  # Ed_MultiPageIndCar
            cursor.execute(self.SqlInsert, Jason)
            self.connLog.commit()
            Ord += 1

    def get_onepage(self, make, model, year, Loop):
        """
            Get The Correct URL
            Get Url Car Data
            Check there is data to insert
            Once cycle's loop has no MMY of cycle, then next cycle
        """
        urlused = self.get_url(make, model, year, Loop)
        cars = self.get_data(urlused, make, model, year, Loop)
        if len(cars) > 0:
            self.log_data(cars, make, model, year, Loop)
            NoData = 0
        else:
            # Flip the Loop Off
            NoData = 1
        return NoData

    def get_allpages(self):
        """
            Loop thru table of MMY given
        """
        for index, row in self.MakeModelYear.iterrows():
            make = str(row['Make'])
            model = str(row['Model'])
            year = str(row['Year'])
            # Run Loop Until No More Data
            NoData = 0
            Loop = 1
            while NoData == 0:
                sleep(2)    # Don't Bombard Them Yo
                # Call URL, Clean Data, Log Data
                NoData = self.get_onepage(make, model, year, Loop)
                Loop += 1   # Count the Loops
