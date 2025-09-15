import cooccurrence as co
import pandas as pd
import numpy as np

df = pd.read_csv("example.csv")

print(df.info())

cc = co.get_cooccur(df)
print(cc)