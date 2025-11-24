#!/usr/bin/env python
# coding: utf-8

# In[4]:


import pandas as pd
import matplotlib.pyplot as plt

# Load dataset (make sure this file is in the same folder as the notebook)
df = pd.read_csv('/Users/vidhirajeshbhaimistry/Downloads/churn prediction/customer_churn_sample.csv')

# Enable inline plotting
get_ipython().run_line_magic('matplotlib', 'inline')

# ----------------------------------------------------------------------
# 1. Churn distribution
# ----------------------------------------------------------------------

plt.figure(figsize=(6,4))
df['Churn'].value_counts().plot(kind='bar', color=['#4C72B0', '#55A868'])
plt.title('Churn Distribution')
plt.xlabel('Churn')
plt.ylabel('Number of Customers')
plt.tight_layout()
plt.savefig('churn_distribution.png')
plt.show()


# ----------------------------------------------------------------------
# 2. Tenure distribution
# ----------------------------------------------------------------------

plt.figure(figsize=(6,4))
df['tenure'].plot(kind='hist', bins=20)
plt.title('Tenure Distribution (Months)')
plt.xlabel('Tenure')
plt.ylabel('Frequency')
plt.tight_layout()
plt.savefig('tenure_distribution.png')
plt.show()


# ----------------------------------------------------------------------
# 3. Monthly Charges distribution
# ----------------------------------------------------------------------

plt.figure(figsize=(6,4))
df['MonthlyCharges'].plot(kind='hist', bins=20)
plt.title('Monthly Charges Distribution')
plt.xlabel('Monthly Charges (USD)')
plt.ylabel('Frequency')
plt.tight_layout()
plt.savefig('monthly_charges_distribution.png')
plt.show()


# ----------------------------------------------------------------------
# 4. Churn by Contract Type
# ----------------------------------------------------------------------

plt.figure(figsize=(7,5))
df.groupby(['Contract', 'Churn'], observed=True).size().unstack().plot(
    kind='bar', stacked=True, figsize=(7,5)
)
plt.title('Churn by Contract Type')
plt.xlabel('Contract')
plt.ylabel('Number of Customers')
plt.tight_layout()
plt.savefig('contract_churn.png')
plt.show()


# ----------------------------------------------------------------------
# 5. Churn by Tenure Band (with corrected warning)
# ----------------------------------------------------------------------

bins = [0, 12, 24, 36, 48, 60, df['tenure'].max()]
labels = ['0-1 yr', '1-2 yr', '2-3 yr', '3-4 yr', '4-5 yr', '5+ yr']

df['tenure_band'] = pd.cut(
    df['tenure'], 
    bins=bins, 
    labels=labels, 
    include_lowest=True
)

tenure_churn = (
    df.groupby(['tenure_band', 'Churn'], observed=True)
      .size()
      .unstack()
      .fillna(0)
)

plt.figure(figsize=(7,5))
tenure_churn.plot(kind='bar', stacked=True, figsize=(7,5))
plt.title('Churn by Tenure Band')
plt.xlabel('Tenure Band')
plt.ylabel('Number of Customers')
plt.tight_layout()
plt.savefig('tenure_churn.png')
plt.show()

print("All visualizations generated and saved successfully!")


# In[ ]:




