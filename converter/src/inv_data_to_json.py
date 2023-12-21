import pandas as pd
import json
import sys

def to_json(input_path, output_path):
    try:
        df = pd.read_excel(input_path, header=None)

        result_dict = {}

        for i in range(1, len(df)):
            inv_name = f"Inv{i}"
            item = df.iloc[i, 1]
            stack = df.iloc[i, 2]

            new_item = int(item) + i if not pd.isna(item) else None
            new_stack = int(stack) + i if not pd.isna(stack) else None

            result_dict[inv_name] = {"Item": new_item, "Stack": new_stack}

        with open(output_path, 'w') as json_file:
            json.dump(result_dict, json_file, indent=2)
            print(f"Conversion successful. JSON file saved as {output_path}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Example: python inv_data_to_json.py <*.xlsx> <.json>")
        sys.exit(1)

    input_excel_path = sys.argv[1]
    output_json_path = sys.argv[2]

    to_json(input_excel_path, output_json_path)