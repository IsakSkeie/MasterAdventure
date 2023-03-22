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

fig, ax = plt.subplots(figsize = (10,8))
ax.grid()
# Plot the three lines on the same axis
ax.plot(result, label='True Turb',  linewidth = 2)
#ax.plot(Y[0,:], label=f'PCR, RMSE = {rmse_PCR}',alpha = 0.6 ,linewidth = 1.5)
ax.plot(Y[1,:], label=f'PLS, RMSE = {rmse_PLS}',alpha =0.6, linewidth = 1.5)
ax.legend()
# %% [markdown]
# FFT
# apply FFT to each column and compute the magnitude
path = "Data1month1hSampling.csv"
df_data = pd.read_csv(path,delimiter=';')
try:
    df_data.drop(['time'], axis=1)
except:
    print("No Time column present")
    

#%%


Atributes_FFT = ['RIS-QI01_TT_FFT', 'IPU-FB18_FFT', 'SAN3-FB01_FFT', 'ANL1-QI02_FFT', 
             'ANL1-QI01_FFT', 'SAN3-ML01_FFT', 'POL_FT04_FFT', 'IPU_LT01_FFT', 
             'SED5-QI11_FFT']
fft_df = pd.DataFrame(np.abs(np.fft.fft(df_data.values)), columns=df_data.columns)

fft_df.columns = Atributes_FFT
merged_df = df_data.join(fft_df.set_index('key'), on='key')
merged_df.to_excel()

plt.plot(fft_df['ANL1-QI01'])
# %%
