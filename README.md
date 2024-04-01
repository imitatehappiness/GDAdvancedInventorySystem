# GDAdvancedInventorySystem

![GitHub stars](https://img.shields.io/github/stars/imitatehappiness/GDAdvancedInventorySystem?style=social)
![GitHub forks](https://img.shields.io/github/forks/imitatehappiness/GDAdvancedInventorySystem?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/imitatehappiness/GDAdvancedInventorySystem?style=social)
![GitHub followers](https://img.shields.io/github/followers/imitatehappiness?style=social)

This project represents a functional system for efficient inventory management in gaming applications. The system includes several convenient features that facilitate item collection, management, and usage in the game.

## Features
1. Item collection in inventory
2. Drag and Drop
3. Item equipment
4. Storage of items in chest
5. Discarding items from inventory and chest
6. Splitting items for stacks
7. Quick retrieval from the chest
8. Save game data

# Storage of Game Data
Initially, data is stored in [xlsx files](https://github.com/imitatehappiness/GDAdvancedInventorySystem/tree/main/converter/data) for ease of filling. To convert them into json files, [scripts](https://github.com/imitatehappiness/GDAdvancedInventorySystem/tree/main/converter) are utilized. 

The results of script execution will be located in [converter/result](https://github.com/imitatehappiness/GDAdvancedInventorySystem/tree/main/converter/result).


## Launch scripts
```
python run_scripts.py
```

If you need to modify a specific file, use the corresponding command:

```
python src/item_data_to_json.py data/item_data.xlsx result/item_data.json
python src/equipment_data_to_json.py data/equipment_data.xlsx result/equipment_data.json
python src/inv_data_to_json.py  data/inv_data.xlsx result/inv_data.json
python src/chest_data_to_json.py data/chest_data.xlsx result/chest_data.json
```
# License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/imitatehappiness/GDAdvancedInventorySystem/blob/main/LICENSE) file for details.

## Demonstration
![preview1](https://github.com/imitatehappiness/GDAdvancedInventorySystem/assets/79199956/f0a12186-6a58-4972-a4db-23e541145eca)
![preview2](https://github.com/imitatehappiness/GDAdvancedInventorySystem/assets/79199956/d998512d-7d31-4b36-b90e-d8b8c6efaaf8)
