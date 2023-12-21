import pandas as pd
import json
import sys

def to_json(input_file, output_file):
    try:
        df = pd.read_excel(input_file)

        data_dict = {}
        for _, row in df.iterrows():
            item_data = {
                "Name": row["Name"],
                "Category": row["Category"],
                "Type": row["Type"],
                "EquipmentSlot": row["EquipmentSlot"],
                "Stackable": False if pd.isna(row["Stackable"]) else row["Stackable"],
                "Attack": row["Attack"],
                "Defense": None if pd.isna(row["Defense"]) else row["Defense"],
                "Health": None if pd.isna(row["Health"]) else row["Health"],
                "Mana": None if pd.isna(row["Mana"]) else row["Mana"],
                "FoodSatiation": None if pd.isna(row["FoodSatiation"]) else row["FoodSatiation"]
            }
            data_dict[str(int(row["ID"]))] = item_data

        with open(output_file, 'w') as json_file:
            json.dump(data_dict, json_file, indent=2)

        print(f"Conversion successful. JSON file saved as {output_file}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Example: python item_data_to_json.py <*.xlsx> <.json>")
        sys.exit(1)

    input_excel_path = sys.argv[1]
    output_json_path = sys.argv[2]

    to_json(input_excel_path, output_json_path)