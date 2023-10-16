#%%
from gekko import GEKKO

m = GEKKO()
#m.options.SOLVER = 1
eq = m.Param()

x = m.Var(lb = -4.5, ub = 4.5)
y = m.Var(lb = -4.5, ub = 4.5)



#Initialize
x.value = 0
y.value = 0




#Objective: Beales function 
f1 = (1.5-x+x*y)**2
f2 = (2.25-x+x*y**2)**2
f3 = (2.625-x+x*y**3)**2


m.Minimize(f1+f2+f3)



#set Global options
#m.options.IMODE = 3


m.solve()
# %%
