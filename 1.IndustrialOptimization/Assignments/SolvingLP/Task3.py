#%%
from gekko import GEKKO
import numpy as np

m = GEKKO()
#m.options.SOLVER = 1
eq = m.Param()



""" var[Grade][Constituent] """
var = [[],[],[]]
for i in range(3):
    for n in range(4):
        var[i].append(m.Var(lb = 0))
        var[i][n].value = 1


A = var[0][0] + var[0][1] + var[0][2] + var[0][3]
B = var[1][0] + var[1][1] + var[1][2] + var[1][3]
C = var[2][0] + var[2][1] + var[2][2] + var[2][3]

# #Equations
#Constraints for Constituents
m.Equation(var[0][0] + var[1][0] + var[2][0]<=3000)
m.Equation(var[0][1] + var[1][1] + var[2][1]<=2000)
m.Equation(var[0][2] + var[1][2] + var[2][2]<=4000)
m.Equation(var[0][3] + var[1][3] + var[2][3]<=1000)

#Constraints for A
m.Equation(var[0][0]/(var[0][0]+var[0][1]+var[0][2]+var[0][3])<=0.3)
m.Equation(var[0][1]/(var[0][0]+var[0][1]+var[0][2]+var[0][3])>=0.4)
m.Equation(var[0][2]/(var[0][0]+var[0][1]+var[0][2]+var[0][3])<=0.5)

#Constraints for B
m.Equation(var[1][0]/(var[1][0]+var[1][1]+var[1][2]+var[1][3])<=0.5)
m.Equation(var[1][1]/(var[1][0]+var[1][1]+var[1][2]+var[1][3])>=0.1)

#Constraints for C
m.Equation(var[2][0]/(var[2][0]+var[2][1]+var[2][2]+var[2][3])<=0.7)

# #Objective
constituent_cost = (-3*(var[0][0] + var[1][0] + var[2][0])
                    -6*(var[0][1] + var[1][1] + var[2][1])
                    -4*(var[0][2] + var[1][2] + var[2][2])
                    -5*(var[0][3] + var[1][3] + var[2][3]))

profit = 5.5*A + 4.5*B + 3.5*C + constituent_cost  
     

m.Maximize(profit)



#set Global options
m.options.IMODE = 3

m.solve()

# %%
