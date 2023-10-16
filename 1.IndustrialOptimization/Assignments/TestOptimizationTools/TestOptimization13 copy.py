#%%
from gekko import GEKKO
import numpy as  np


m = GEKKO()
m.options.SOLVER = 1


lbx = -1.5
ubx = 1.5
lby = -0.5
uby = 2.5

res = 2

grid = [np.linspace(lbx,ubx,res), np.linspace(lby,uby,res)]

eq = m.Param()
x = m.Var(lb = lbx, ub = ubx)
y = m.Var(lb = lby, ub = lby)


for xn in range(res):
    for yn in range(res):
        
        #Initialize, fails with init 0,0
        x.value = grid[0][xn]
        y.value = grid[1][yn]

        #Equations
        m.Equation((x-1)**3-y+1<=0)
        m.Equation(x+y-2<=0)



        #Objective
        f1 = (1-x)**2
        f2 = 100*((y-x**2)**2)



        min =  m.Minimize(f1+f2)

        print(xn, yn)

        #set Global options
        m.options.IMODE = 3


        m.solve()
# %%
