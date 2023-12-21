extends Node

var config_path = "res://config.json"

var item_data = {}
var item_data_path

var chest_data = {}
var chest_data_path

var item_stats = ["Attack", "Defense", "Health", "Mana", "FoodSatiation"]
var item_stats_label = ["Attack", "Defense", "Health", "Mana", "Satiation"]

func _ready():
	load_data_path()
	load_item_data()
	load_chest_data()

func load_data_path():
	var config = FileAccess.open(config_path, FileAccess.READ)
	if not config:
		print("Error: Unable to open config for reading.")
		return
	var json = JSON.new()

	if json.parse(config.get_as_text()) != OK:
		print("Error: Failed to parse JSON from inv_data_file.")
		json.close()
		return

	config.close()
	var data = json.get_data()
	item_data_path = data["item_data_file_path"]
	chest_data_path = data["chest_data_file_path"]
	
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
