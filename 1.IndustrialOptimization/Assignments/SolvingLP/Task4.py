#%%
from gekko import GEKKO
import numpy as np

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()


var = [[],[],[]]
"""Var[n][:] represents the farms, Var[:][n] represents crops"""
for i in range(3):
    for n in range(3):
        var[i].append(m.Var(lb = 0))
        var[i][n].value = 1


A = var[0][0] + var[1][0] + var[2][0]
B = var[0][1] + var[1][1] + var[2][1]
C = var[0][2] + var[1][2] + var[2][2]


#Constraint for Crop Area
for i in range(3):
    m.Equation(var[i][0]<=350)
    m.Equation(var[i][1]<=400)
    m.Equation(var[i][2]<=150)

#Constraints for land
m.Equation(var[0][0]+var[0][1]+var[0][2]<=200)
m.Equation(var[1][0]+var[1][1]+var[1][2]<=150)
m.Equation(var[2][0]+var[2][1]+var[2][2]<=300)

#Constraints for water conumption
m.Equation(1.6*var[0][0]+1.3*var[0][1]+var[0][2]<=250)
m.Equation(1.6*var[1][0]+1.3*var[1][1]+var[1][2]<=333)
m.Equation(1.6*var[2][0]+1.3*var[2][1]+var[2][2]<=150)

#constraints in usable area
m.Equation((var[0][0]+var[1][0]+var[2][0])/200==(var[0][1]+var[1][1]+var[2][1])/150)
m.Equation((var[0][0]+var[1][0]+var[2][0])/200==(var[0][2]+var[1][2]+var[2][2])/300)

m.Equation((var[0][2]+var[1][2]+var[2][2])/300==(var[0][1]+var[1][1]+var[2][1])/150)
m.Equation((var[0][2]+var[1][2]+var[2][2])/300==(var[0][0]+var[1][0]+var[2][0])/200)

m.Equation((var[0][1]+var[1][1]+var[2][1])/150==(var[0][0]+var[1][0]+var[2][0])/200)
m.Equation((var[0][1]+var[1][1]+var[2][1])/150==(var[0][2]+var[1][2]+var[2][2])/300)




# #Objective
profit = (800*A + 600*B + 100*C)
m.Maximize(profit)



# #set Global options
# m.options.IMODE = 3

m.solve()

# %%
