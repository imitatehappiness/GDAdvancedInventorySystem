import pandas as pd
import json
import sys

def to_json(input_file, output_file):
    try:
        df = pd.read_excel(input_file)
        equipment_row = df.iloc[0]
        equipment_dict = {slot: None if pd.isna(item) else int(item) for slot, item in equipment_row.items()}
        json_result = json.dumps(equipment_dict, indent=2)

        with open(output_file, 'w') as json_file:
            json_file.write(json_result)

        print(f"Conversion successful. JSON file saved as {output_file}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Example: python equipment_data_to_json.py <*.xlsx> <.json>")
        sys.exit(1)

    input_excel_path = sys.argv[1]
    output_json_path = sys.argv[2]

    to_json(input_excel_path, output_json_path)