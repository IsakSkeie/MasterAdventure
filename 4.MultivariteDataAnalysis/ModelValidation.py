#%% [markdown]
# Importing Data
# %%
import numpy as np
from matplotlib import pyplot as plt
import pandas as pd

path  =  "ValidatingData.xlsx"
df = pd.read_excel(path)
#df= (df-df.mean())/df.std()
df = df.apply(lambda column: (column -column.mean())/column.std())
#normalized_df=(df-df.min())/(df.max()-df.min())
Atributes = ['RIS-QI01_TT', 'IPU-FB18', 'SAN3-FB01', 'ANL1-QI02', 
             'ANL1-QI01', 'SAN3-ML01', 'POL_FT04', 'IPU_LT01', 
             'SED5-QI11']
Y_Name = 'SED5-QI01'
n = len(Atributes)
#%% [markdown]
#Plot validating Turbidity
column = 'POL_FT04'
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

m = len(df_coeff.index)

Y = np.zeros([m, len(df.index)])
for atrb in range(m):
    for i in range(n):
        Y[atrb] =  Y[atrb] + df[Atributes[i]]*df_coeff[Atributes[i]].loc[atrb]

# %%

plt.plot(Y[:,0])
# %%
