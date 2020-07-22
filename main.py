
# # # # Packages # # # #
from functions import Scrapper
from sqlconn import get_MMY
import os


# Needed Values / Variables / Data
###############################################################
drive = 'C:\\Users\\Quinn\\Desktop\\Car Scrapper\\JsonStorage'
MakeModelYear = get_MMY()

# Create Car Scrapper
###############################################################
CarGetter = Scrapper(drive,  MakeModelYear)
CarGetter.MakeModelYear
CarGetter.loc

# Set the Scrapper Loose
###############################################################
CarGetter.get_allpages()
