import pandas as pd
import json
import sys

def to_json(input_path, output_path):
    try:
        result_dict = {}
        index = 0
        item_index = 1
        inner_dict = {}

        df = pd.read_excel(input_path)
        for j in range(0, len(df)):

            inv_name = f"Inv{item_index}"
            item = df.iloc[j, 1]
            stack = df.iloc[j, 2]

            if item != "Item":
                new_item = int(item) if not pd.isna(item) else None
                new_stack = int(stack)  if not pd.isna(stack) else None
                inner_dict[inv_name] = {"Item": new_item, "Stack": new_stack}
                item_index += 1
            else: 
                item_index = 1
                result_dict[str(index)] = inner_dict.copy()
                inner_dict.clear()
                index = int(df.iloc[j, 0])

        result_dict[str(index)] = inner_dict

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
