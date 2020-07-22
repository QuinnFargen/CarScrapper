
# # # # Packages # # # #
import requests
import os
from time import sleep
from datetime import date
from bs4 import BeautifulSoup


# Where txt Files Saved
os.getcwd()
os.chdir('C:\\Users\\Quinn\\Desktop\\Car Scrapper\\JsonStorage')
os.getcwd()


#############################################
# Functions: to Reduce Loop Below

def get_url(make, model, year, Loop):
    urlbase = "https://www.edmunds.com/"
    pagenum = '?pagenumber='
    url = urlbase + make + '/' + model + '/' + year + '/'
    # PageNumbers for everything, first page no PageNum
    if Loop == 1:
        urlused = url
    else:
        urlused = url + pagenum + str(Loop)
    return urlused


def write_drive(urltext, make, model, year, Loop):
    dt = date.today().strftime("%Y_%m_%d")
    try:
        FileName = dt + '_' + make + '_' + model + \
            '_' + year + '_' + str(Loop) + ".txt"
        writeTxt = open(FileName, "w")
        writeTxt.write(urltext)
        writeTxt.close()
    except:
        pass


def get_data(urlused, make, model, year, Loop):
    # Request Website
    header = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4040.128"}
    r = requests.get(urlused, headers=header, timeout=5)
    # Cook The Soup
    soup = BeautifulSoup(r.text, 'html.parser')
    # Pull Script Portion (Car Data)
    scripttext = soup.find('script').getText()
    # Write To Drive
    write_drive(scripttext, make, model, year, Loop)
    # Seperate the Cars into a List
    scriptlist = scripttext.split("},{")
    # Only Want Cars, Junk start & end
    i = 0
    cars = []
    while i < len(scriptlist):
        # Want Data to be Vehicle, Make, Model, & Year
        if '"@type":"Vehicle"' in scriptlist[i] and make in scriptlist[i] and model in scriptlist[i] and year in scriptlist[i]:
            cars.append(scriptlist[i])
        i += 1
    return cars


def log_data(cars, make, model, year, Loop):
    # Write to Sql Server
    # print(make + '|' + model + '|' + year + '|' + str(Loop))
    Ord = 0
    while Ord < len(cars):
        Jason = [make + '|' + model + '|' + year + '|' + str(Loop) + '|' + str(Ord),
                 '[{' + cars[Ord].replace("@", "").strip() + '}]']
        cursor.execute(sql, Jason)
        connLog.commit()
        Ord += 1


def get_onepage(make, model, year, Loop):
    #############################################
    # Get The Correct URL
    urlused = get_url(make, model, year, Loop)
    #############################################
    # Get Url Car Data
    cars = get_data(urlused, make, model, year, Loop)
    # print(len(cars))
    #############################################
    # Check there is data to insert
    if len(cars) > 0:
        log_data(cars, make, model, year, Loop)
        NoData = 0
    else:
        # Flip the Loop Off
        NoData = 1
    return NoData


def get_allpages(make, model, year):
    # Run Loop Until No More Data
    NoData = 0
    Loop = 1
    while NoData == 0:
        #############################################
        # Don't Bombard Them Yo
        sleep(2)
        #############################################
        # Call URL, Clean Data, Log Data
        NoData = get_onepage(make, model, year, Loop)
        #############################################
        # Count the Loops
        Loop += 1


#####################################################################
#####################################################################
#####################################################################
#####################################################################


# # Website Values
# make = "toyota"
# model = "camry"
# year = "2018"
#####################################################################
for index, row in MakeModelYear.iterrows():
    make = str(row['Make'])
    model = str(row['Model'])
    year = str(row['Year'])
    get_allpages(make, model, year)
