#%%
from gekko import GEKKO
import numpy as np

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()


g1p1 = m.Var(lb = 0, ub = 1, integer = True)
g1p2 = m.Var(lb = 0, ub = 1, integer = True)
g2p1 = m.Var(lb = 0, ub = 1, integer = True)
g2p2 = m.Var(lb = 0, ub = 1, integer = True)
g3p1 = m.Var(lb = 0, ub = 1, integer = True)
g3p2 = m.Var(lb = 0, ub = 1, integer = True)

g1p1.value = 0
g1p2.value = 0
g2p1.value = 0
g2p2.value = 0
g3p1.value = 0
g3p2.value = 0



#Equations

m.Equation(1900*g1p1+1700*g2p1+2900*g3p1 >=2500)
m.Equation(1900*g1p2+1700*g2p2+2900*g3p2 >= 3500)




#Objective
fixed_costs = 2800*(g1p1+g1p2-g1p1*g1p2)+2000*(g2p1+g2p2-g2p1*g2p2)+1900*(g3p1+g3p2-g2p1*g3p2)
cost = (fixed_costs+5*g1p1+5*g1p2+3*g2p1+3*g2p2+8*g3p1+8*g3p2)

m.Minimize(cost)



#set Global options
m.options.IMODE = 3

m.solve()

text = f"Generator1 period[1,2]=[{g1p1.value},{g1p2.value}], Generator2 period[1,2]= [{g2p1.value},{g2p2.value}],Generator3 period[1,2]= [{g3p1.value},{g3p2.value}]"
print(text)
# %%
