import pandas as pd
import numpy as np
    
import pandas as pd
import numpy as np

def get_cooccur(df):
    """
    Calculates co-occurrence matrices per Age group and Insurance group (vectorized).
    Args:
        df (pd.DataFrame): A DataFrame with columns 'PatientID', 'Code', 'Time',
                           'nOccurrences', 'Insurance', and 'Age'.
    Returns:
        tuple: tensor, a 4D numpy array of shape (n_codes, n_codes, n_insurances, n_age_groups)
    """
    age_labels = ['Age < 20', '20 <= Age <= 40', '41 <= Age <= 60', 'Age > 60']
    df = df.copy()
    df['AgeGroup'] = pd.cut(
        df['Age'],
        bins=[-np.inf, 19, 40, 60, np.inf],
        labels=age_labels
    )

    all_codes = sorted(df['Code'].unique())
    code_to_idx = {code: i for i, code in enumerate(all_codes)}
    insurances = sorted(df['Insurance'].unique())
    ins_to_idx = {ins: i for i, ins in enumerate(insurances)}
    age_to_idx = {label: i for i, label in enumerate(age_labels)}

    n_codes = len(all_codes)
    n_insurances = len(insurances)
    n_age_groups = len(age_labels)

    # Single self-join on Time, PatientID, Insurance, and AgeGroup
    merged = pd.merge(
        df, df,
        on=['Time', 'PatientID', 'Insurance', 'AgeGroup'],
        suffixes=('_1', '_2')
    )
    merged['min_occurrences'] = merged[['nOccurrences_1', 'nOccurrences_2']].min(axis=1)

    # Aggregate all groups at once
    agg = (
        merged.groupby(['Code_1', 'Code_2', 'Insurance', 'AgeGroup'], observed=True)['min_occurrences']
        .sum()
        .reset_index()
    )

    # Map categorical columns to integer indices
    row_idx = agg['Code_1'].map(code_to_idx).values
    col_idx = agg['Code_2'].map(code_to_idx).values
    ins_idx = agg['Insurance'].map(ins_to_idx).values
    age_idx = agg['AgeGroup'].map(age_to_idx).values
    values = agg['min_occurrences'].values

    # Scatter into the 4D tensor in one vectorized operation
    tensor = np.zeros((n_codes, n_codes, n_insurances, n_age_groups), dtype=np.float64)
    np.add.at(tensor, (row_idx, col_idx, ins_idx, age_idx), values)

    return tensor
    
    
    
    