import os
import time
import requests
import pandas as pd

# 1. DEFINE SCHEME CODES HERE
SCHEME_CODES = ["119551", "120503", "118632", "119092", "120841"]  

# Destination folder for raw data
OUTPUT_DIR = "./data/raw"
os.makedirs(OUTPUT_DIR, exist_ok=True)

print(f"🚀 Starting ingestion pipeline for {len(SCHEME_CODES)} schemes...\n")

# 2. Loop through each scheme code
for idx, scheme_code in enumerate(SCHEME_CODES, start=1):
    API_URL = f"https://api.mfapi.in/mf/{scheme_code}"
    print(f"[{idx}/{len(SCHEME_CODES)}] Fetching Scheme Code: {scheme_code}...")
    
    try:
        # Make the live network request
        response = requests.get(API_URL, timeout=10) # Added a 10-second timeout safety
        
        if response.status_code == 200:
            # Parse the JSON response
            json_data = response.json()
            all_nav_history = json_data.get('data', [])
            
            if not all_nav_history:
                print(f"⚠️ Warning: No data returned for scheme {scheme_code}. Skipping.")
                continue
                
            # Take only the top 100 most recent records
            top_100_nav = all_nav_history[:100]
            
            # Convert to Pandas DataFrame
            df_nav = pd.DataFrame(top_100_nav)
            
            # Map metadata
            df_nav['scheme_code'] = scheme_code
            df_nav['scheme_name'] = json_data.get('meta', {}).get('scheme_name', 'Unknown')
            
            # Reorder columns
            df_nav = df_nav[['date', 'nav', 'scheme_code', 'scheme_name']]
            
            # Save individual raw file
            output_file_path = os.path.join(OUTPUT_DIR, f"nav_raw_{scheme_code}.csv")
            df_nav.to_csv(output_file_path, index=False)
            
            print(f"✅ Successfully saved {len(df_nav)} records to: {output_file_path}\n")
            
        else:
            print(f"❌ Failed for {scheme_code}. HTTP Status Code: {response.status_code}\n")
            
    except Exception as e:
        print(f"❌ An error occurred processing scheme {scheme_code}: {e}\n")
    
    # 3. Rate limiting courtesy delay (Pause for 1 second before hitting the server again)
    time.sleep(1)

