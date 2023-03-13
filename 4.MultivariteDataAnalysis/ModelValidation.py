#%% [markdown]
# Importing Data
# %%
import numpy as np
from matplotlib import pyplot as plt
import pandas as pd

path  =  "ValidatingData.xlsx"
df = pd.read_excel(path)

Atributes = ['RIS-QI01_T', 'IPU-FB18', 'SAN3-FB01', 'ANL1-QI02', 
             'ANL1-QI01', 'SAN3-ML01', 'POL_FT04', 'IPU_LT01', 
             'SED5-QI11']
Y_Name = 'SED5-QI01'
n = len(Atributes)
#%% [markdown]
#Plot validating Turbidity
column = 'POL_FT04.POL_FT04 VERDI:Value'
result = df[column]
fig = plt.figure(figsize=(10, 6))
plt.grid()
plt.title("Turbidity")
plt.xlabel("1/0.1 min")

plt.legend()
plt.plot(result, linewidth=0.35)

# %% [markdown]
# Creating the polynomial
df_coeff = pd.read_excel("ModelCoefficients.xlsx")
Coefficients = np.zeros(n)

for i in range(n):
    Coefficients[i] = df_coeff[Atributes[i]]    
Coefficients = Coefficients.T
#%%
def RunModel(Coefficients, ValData, Atributes):
    Y = np.zeros(len(df.index))
    k = 0
    for instance in ValData:
        Y_k = 0
        for i in range(n):
            Y_k = Y_k + instance[Atributes[i]]*Coefficients[Atributes[i]]
        Y[k] = Y_k
    return Y
# %%

Y = RunModel(Coefficients, df, Atributes)

# %%
