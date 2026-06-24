import os
import pandas as pd

# Point directly to the local folder
data_directory = "./data/raw/"

# Read every CSV in the folder
for file in os.listdir(data_directory):
    if file.endswith('.csv'):
        file_path = os.path.join(data_directory, file)
        
        # Load into pandas
        df = pd.read_csv(file_path)
        
        print(f"\n--- Dataset: {file} ---")
        print(f"Shape: {df.shape}")
        print("\nData Types:")
        print(df.dtypes)
        print("\nHead:")
        print(df.head(3))
        print("="*40)