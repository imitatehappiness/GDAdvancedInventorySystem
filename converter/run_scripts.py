import subprocess

def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True)
        print(f"Command successful: {command}")
    except subprocess.CalledProcessError as e:
        print(f"Error executing command '{command}': {e}")

if __name__ == "__main__":
    commands = [
        "python src/item_data_to_json.py data/item_data.xlsx result/item_data.json",
        "python src/equipment_data_to_json.py data/equipment_data.xlsx result/equipment_data.json",
        "python src/inv_data_to_json.py data/inv_data.xlsx result/inv_data.json",
        "python src/chest_data_to_json.py data/chest_data.xlsx result/chest_data.json"
    ]

    for command in commands:
        run_command(command)