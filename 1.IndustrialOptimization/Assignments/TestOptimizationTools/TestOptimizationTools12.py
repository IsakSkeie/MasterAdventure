#%%
from gekko import GEKKO

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()

x = m.Var(lb = -10, ub = 10)
y = m.Var(lb = -10, ub = 10)



#Initialize
x.value = 0
y.value = 0





#Objective: Himmelbaus function
f1 = (x**2+y-11)**2
f2 = (x+y**2-7)**2


#We have several solutions to this problem, could test with several initial values
m.Minimize(f1+f2)



#set Global options
m.options.IMODE = 3


m.solve()
# %%
