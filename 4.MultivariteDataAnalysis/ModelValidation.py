#%% [markdown]
# Importing Data
# %%
import numpy as np
from matplotlib import pyplot as plt
import pandas as pd

path  =  "ValidatingData.xlsx"
path  =  "val2__CenterAndScale_MovingAverage.xlsx"
df = pd.read_excel(path)

# Data is already processed in Unscrambler
#df = df.apply(lambda column: (column -column.mean())/column.std())
#df = df.rolling(window=9, center = True).mean()
#normalized_df=(df-df.min())/(df.max()-df.min())
Atributes = ['RIS-QI01_TT', 'IPU-FB18', 'SAN3-FB01', 'ANL1-QI02', 
             'ANL1-QI01', 'SAN3-ML01', 'POL_FT04', 'IPU_LT01', 
             'SED5-QI11']
Y_Name = 'SED5-QI01'
n = len(Atributes)
#%% [markdown]
# Plot validating Turbidity
result = df[Y_Name]
fig = plt.figure(figsize=(10, 6))
plt.grid()
plt.title("Turbidity")
plt.xlabel("1/0.1 min")

plt.legend()
plt.plot(result, linewidth=0.7)

# %% [markdown]
# Creating the Creating Modelled Turbidity through Coefficients and Val. Data
df_coeff = pd.read_excel("ModelCoefficients.xlsx")
m = len(df_coeff.index)
Y = np.zeros([m, len(df.index)])
for atrb in range(m):
    for i in range(n):
        Y[atrb] =  Y[atrb] + df[Atributes[i]]*df_coeff[Atributes[i]].loc[atrb]

# %% [markdown]
# Calculate RMSE
rmse_PCR = np.sqrt(np.mean((result - Y[0,:])**2)).round(4)
rmse_PLS = np.sqrt(np.mean((result - Y[1,:])**2)).round(4)
# %% [markdown]
# Plot the results

fig, ax = plt.subplots(figsize = (15,8))
ax.grid()
# Plot the three lines on the same axis
ax.plot(result, label='True Turb',  linewidth = 1)
ax.plot(Y[0,:], label=f'PCR, RMSE = {rmse_PCR}',alpha = 0.8 ,linewidth = 0.4)
ax.plot(Y[1,:], label=f'PLS, RMSE = {rmse_PLS}',alpha =0.8, linewidth = 0.4)
ax.legend()
# %%
