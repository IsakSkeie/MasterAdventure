#%% [markdown]
# Importing Data
# %%
import numpy as np
from matplotlib import pyplot as plt
import pandas as pd

path  =  "ValidatingData.xlsx"
df = pd.read_excel(path)
#%% [markdown]
#Plot validating Turbidity
column = 'POL_FT04.POL_FT04 VERDI:Value'
result = df[column]
plt.grid()
plt.title("Turbidity")
plt.xlabel("1/0.1 min")

plt.legend()
plt.plot(result)

# %%
