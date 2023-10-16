# -*- coding: utf-8 -*-
"""
Created on Tue Sep 21 10:44:01 2021

@author: isak.skeie
"""


import pandas as pd





if __name__ == '__main__':
    

    #%% parameters
    A_Installation = 160000
    A_Operational = 2200
    B_Installation1 = 34000
    B_Installation2 = 58000
    B_Operational = 25000
    B_Salvage = -5600
    A_lifespan = 30
    B_lifespan1 = 10
    B_lifespan2 = 30
    IR = 0.12
    
    #%% CAlculations
    df = pd.read_excel('Assignment1.xlsx', sheet_name='Task1.12')
    
     