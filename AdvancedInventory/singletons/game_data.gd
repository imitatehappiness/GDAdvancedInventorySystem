extends Node

var item_data = {}
const item_data_path = "res://data/ItemData - Sheet1.json"

var chest_data = {}
const chest_data_path = "res://data/chest_data.json"

var item_stats = ["Attack", "Defense", "Health", "Mana", "FoodSatiation"]
var item_stats_label = ["Attack", "Defense", "Health", "Mana", "Satiation"]

func _ready():
	load_item_data()
	load_chest_data()

func load_item_data():
	var item_data_file = FileAccess.open(item_data_path, FileAccess.READ)
	var item_data_json = JSON.new()
	item_data_json.parse(item_data_file.get_as_text())
	item_data_file.close()
	item_data = item_data_json.get_data()

func load_chest_data():
	var chest_data_file = FileAccess.open(chest_data_path, FileAccess.READ)
	
	if not chest_data_path:
		print("Error: Unable to open equipment_data_file for reading.")
		return
	
	var chest_data_json = JSON.new()
	
	if chest_data_json.parse(chest_data_file.get_as_text()) != OK:
		print("Error: Failed to parse JSON from equipment_data_file.")
		chest_data_file.close()
		return
	
	chest_data_file.close()
	chest_data = chest_data_json.get_data()

func save_chest_data():
	var chest_data_file = FileAccess.open(chest_data_path, FileAccess.WRITE)
	
	if not chest_data_file:
		print("Error: Unable to open inv_data_file for writing.")
		return

	var json_string = JSON.stringify(chest_data, "", false)

	chest_data_file.store_string(json_string)
	chest_data_file.close()
