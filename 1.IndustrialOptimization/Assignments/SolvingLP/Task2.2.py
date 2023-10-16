# -*- coding: utf-8 -*-
"""
Created on Sun Oct 10 12:52:13 2021

@author: isak.skeie
"""
#%%

from gekko import GEKKO

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()

x1 = m.Var(lb = 0, integer=True)
x2 = m.Var(lb = 0, integer=True)
x3 = m.Var(lb = 0, integer=True)


#Initialize
x1.value = 1
x2.value = 1
x3.value = 1


#Equations
m.Equation(x1+x2+x3>=1)
m.Equation(100*x1+10*x2+10*x3>=50)
m.Equation(10*x1+100*x2+10*x3>=10)


#Objective
m.Minimize(x1+2*x2+0.5*x3)



#set Global options
m.options.IMODE = 3

m.solve()

# %%
