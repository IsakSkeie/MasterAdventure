#%%
import scipy.optimize as optimize

def f(x, y):
    z = (1-x)**2+100*(y-x**2)**2
    return z

x_0 = 0
y_0 = 0

result = optimize.minimize(f, x_0, y_0)

if result.success: print(result)


# %%
