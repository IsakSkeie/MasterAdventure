#%%
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 10 12:52:13 2021

@author: isak.skeie
"""
#%%
#Library used is called Gekko, install with 'pip install gekko', or find it at https://gekko.readthedocs.io/en/latest/
from gekko import GEKKO

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()

x1 = m.Var(lb = 0, integer=True)
x2 = m.Var(lb = 0, integer = True)
x3 = m.Var(lb = 0, ub = 20, integer = True)


#Initialize
x1.value = 1
x2.value = 1
x3.value = 1


#Constraints for the time used on the machines
m.Equation(8*x1+2*x2+3*x3<=200)
m.Equation(4*x1+3*x2<=100)
m.Equation(2*x1+x3<=50)


#Objective
m.Maximize(200*x1+60*x2+80*x3)



#set Global options
m.options.IMODE = 3

m.solve()

# %%
