# Compute co-occurrence matrix from EHR data

Author: Parker Knight (pknight@g.harvard.edu)


The file `cooccurrence.R` provides a function called `getCooccur` for computing co-occurrence matrices from EHR time series data.
The interface of the function is determined by the option `byPatient`. If `byPatient` is FALSE (which is the default setting), the 
function takes as input a dataframe with columns "Code", "Time", and "nOccurrences". Each row of this dataframe corresponds to the number of
observed occurrences of a given code during a given time point. For example, if the dataframe includes a row of the form
"Code3, 2, 15", this means that Code3 occurred 15 times across all patients in Week 2.
If `byPatient` is TRUE, the `getCooccur` function takes two inputs: a dataframe with columns "PatientID", "Code", and "Time", and a window length parameter. 
In either case, the "Time" column in the dataframe should denote the time at which code $j$ is observed for patient $i$ *since the index date*. The units 
in which the observation time is recorded is not important as long as it is consistent with the specified window length.

The files `example.csv` and `example_byPatient.csv` contain dataframes formatted correctly. The following block of code returns a 10x10 co-occurrence matrix.

```
df <- read.csv("example.csv")
getCooccur(df)

df_bp <- read.csv("example_byPatient.csv")
getCooccur(df_bp, window = 1, byPatient = TRUE)
```

The slides from our tutorial presentation are found in the
`kg-tutorial-slides.pdf` file.
