#%%
from gekko import GEKKO
import numpy as np

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()


g11 = m.Var(lb = 0, ub = 1, integer = True)
g12 = m.Var(lb = 0, ub = 1, integer = True)
g13 = m.Var(lb = 0, ub = 1, integer = True)
g14 = m.Var(lb = 0, ub = 1, integer = True)
g15 = m.Var(lb = 0, ub = 1, integer = True)
g21 = m.Var(lb = 0, ub = 1, integer = True)
g22 = m.Var(lb = 0, ub = 1, integer = True)
g23 = m.Var(lb = 0, ub = 1, integer = True)
g24 = m.Var(lb = 0, ub = 1, integer = True)
g25 = m.Var(lb = 0, ub = 1, integer = True)
g31 = m.Var(lb = 0, ub = 1, integer = True)
g32 = m.Var(lb = 0, ub = 1, integer = True)
g33 = m.Var(lb = 0, ub = 1, integer = True)
g34 = m.Var(lb = 0, ub = 1, integer = True)
g35 = m.Var(lb = 0, ub = 1, integer = True)


g11.value = 0
g12.value = 0
g13.value = 0
g14.value = 0
g15.value = 0
g21.value = 0
g22.value = 0
g23.value = 0
g24.value = 0
g25.value = 0
g31.value = 0
g32.value = 0
g33.value = 0
g34.value = 0
g35.value = 0


Generators = [[g11,g12,g13,g14,g15],[g21,g22,g23,g24,g25],[g31,g32,g33,g34,g35]]

#Equations through the years
year1 = 700+10*g11+50*g21+100*g31
year2 = year1+10*g12+50*g22+100*g23
year3 = year2+10*g13+50*g23+100*g33
year4 = year3+10*g14+50*g24+100*g34
year5 = year4+10*g15+50*g25+100*g35

m.Equation(year1>=780)
m.Equation(year2>=860)
m.Equation(year3>=950)
m.Equation(year4>=1060)
m.Equation(year5>=1180)



#Objective

cost = (280*g11+230*g12+188*g13+153*g14+135*g15
        +650*g21+538*g22+445*g23+367*g24+300*g25
        +700*g31+771*g32+640*g33+530*g34+430*g35)


m.Minimize(cost)



#set Global options
m.options.IMODE = 3

m.solve()
print(Generators)
# %%
