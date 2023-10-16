#%%
from gekko import GEKKO
import numpy as np

m = GEKKO()
m.options.SOLVER = 1
eq = m.Param()


p1 = m.Var(lb = 0, ub = 1, integer = True)
p2 = m.Var(lb = 0, ub = 1, integer = True)
p3 = m.Var(lb = 0, ub = 1, integer = True)
p4 = m.Var(lb = 0, ub = 1, integer = True)
p5 = m.Var(lb = 0, ub = 1, integer = True)
p6 = m.Var(lb = 0, ub = 1, integer = True)

p1.value = 0
p2.value = 0
p3.value = 0
p4.value = 0
p5.value = 0
p6.value = 0






# #Equations

m.Equation(p1 + p2 == 1)
m.Equation(p1 + p3 <= 1)
m.Equation(p5*p6==0)

m.Equation(300000*p1+100000*p2+50000*p4+50000*p5+100000*p6 <= 450000)
m.Equation(300000*p2+200000*p3+100000*p4+300000*p5+200000*p6 <= 400000)
m.Equation(400*p1+7000*p2+2000*p3+6000*p4+3000*p5+600*p6<=10000)


# #Objective
profit = (100000*p1+150000*p2+35000*p3+75000*p4+125000*p5+60000*p6)

m.Maximize(profit)



#set Global options
m.options.IMODE = 3

m.solve()

text = f"Generator1 ={p1.value}, Generator2 = {p2.value}, Generator3 = {p3.value}"
print(text)
# %%
