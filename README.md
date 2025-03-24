# Compute co-occurrence matrix from EHR data

Author: Parker Knight (pknight@g.harvard.edu)


The file `cooccurrence.R` provides a function called `getCooccur` for computing co-occurrence matrices from EHR time series data.
The function takes two inputs: a dataframe with columns "PatientID", "Code", and "Time", and a window length parameter. 
The "Time" column in the dataframe should denote the time at which code $j$ is observed for patient $i$ *since the index date*. The units 
in which the observation time is recorded is not important as long as it is consistent with the specified window length.

The file `example.csv` contains a dataframe formatted correctly. The following block of code returns a 10x10 co-occurrence matrix.

```
df <- read.csv("example.csv")
getCooccur(df, window = 2)
```
