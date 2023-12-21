# GDAdvancedInventorySystem

This project represents a functional system for efficient inventory management in gaming applications. The system includes several convenient features that facilitate item collection, management, and usage in the game.

## Features
1. Item collection in inventory
2. Drag and Drop
3. Item equipment
4. Storage of items in chest
5. Splitting items for stacks
6. Quick retrieval from the chest
7. Save items data

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

## Demonatration
![preview](https://github.com/imitatehappiness/GDAdvancedInventorySystem/assets/79199956/70ea35c2-2479-44ae-867d-9f468f315264)
