import pandas as pd
import numpy as np
    
def get_cooccur(df):
    """
    Calculates the co-occurrence matrix of codes using an efficient vectorized approach.

    Args:
        df (pd.DataFrame): A DataFrame with columns 'PatientID', 'Code', 'Time', and 'nOccurrences'.

    Returns:
        pd.DataFrame: A co-occurrence matrix with codes as row and column names.
    """
    # Create pairs of co-occurring codes for each unique Time and PatientID
    # by merging the DataFrame with itself.
    merged_df = pd.merge(df, df, on=['Time', 'PatientID'], suffixes=('_1', '_2'))
    
    # Filter out self-comparisons where Code1 is the same as Code2
    cooccur_pairs = merged_df.copy()
    
    # Calculate the minimum number of occurrences for each pair
    cooccur_pairs['min_occurrences'] = cooccur_pairs[['nOccurrences_1', 'nOccurrences_2']].min(axis=1)
    
    # Aggregate the minimum occurrences for each pair using pivot_table
    cooccur_matrix_df = pd.pivot_table(
        cooccur_pairs,
        values='min_occurrences',
        index='Code_1',
        columns='Code_2',
        aggfunc='sum',
        fill_value=0
    )
    # print(cooccur_matrix_df)
    # Calculate the diagonal values (total occurrences for each code)
    total_occurrences = df.groupby('Code')['nOccurrences'].sum()
    
    # Create the final co-occurrence matrix with the diagonal values added
    # cooccur_matrix = cooccur_matrix_df.to_numpy()
    # np.fill_diagonal(cooccur_matrix, total_occurrences.loc[cooccur_matrix_df.index].to_numpy())
    
    return cooccur_matrix_df
    
    
    
    
    