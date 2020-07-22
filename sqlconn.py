
# # # # Packages # # # #
import pypyodbc  # Logging
import pyodbc    # Looping
import pandas as pd


###############################################################
# Sql Server Connection Strings
def get_connQuery():
    return pyodbc.connect("DRIVER={ODBC Driver 17 for SQL Server};"
                          "SERVER=DESKTOP-FK7HVAL\PRACTICEDB;"
                          "DATABASE=Messy;"
                          "Trusted_Connection=yes;")


def get_connLog():
    connLog = pypyodbc.connect("DRIVER={ODBC Driver 17 for SQL Server};"
                               "SERVER=DESKTOP-FK7HVAL\PRACTICEDB;"
                               "DATABASE=Messy;"
                               "Trusted_Connection=yes;")
    cursor = connLog.cursor()
    return connLog


###############################################################
# Sql Code to Insert or Query
def get_SqlInsert():
    return """
            INSERT INTO Messy.dbo.JsonStorage (JasonType, Jason, JsonTypeID)
            VALUES (?, ?, ?)
            """


def get_SqlQuery():
    connQuery = get_connQuery()
    return pd.read_sql_query(
        '''
    SELECT A.Make, A.Model, A.Year
    FROM Messy.Cars.MakeModel A with (NOLOCK)   
    WHERE 1=1
        AND A.Make = 'chevrolet'
        AND A.Model = 'impala'
        AND A.Year = 2010
    ''', connQuery)

    # Possible SQL Where Clause to test on small size:
    # WHERE 1=1
    #     AND A.Make = 'chevrolet'
    #     AND A.Model = 'impala'
    #     AND A.Year = 2015


###############################################################
# Query to get data set to Loop
def get_MMY():
    SQLQuery = get_SqlQuery()
    return pd.DataFrame(SQLQuery, columns=['Make', 'Model', 'Year'])
