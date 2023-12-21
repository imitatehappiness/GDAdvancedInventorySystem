extends Node

var inv_data = {}
const path_inv_data_file = "user://inv_data_file.json"

var equipment_data = {}
const path_equipment_data_file = "user://equipment_data_file.json"

signal update_inventory

func _ready():
	load_inv_data()
	load_equipment_data()

func load_inv_data():
	var inv_data_file = FileAccess.open(path_inv_data_file, FileAccess.READ)

	if not inv_data_file:
		print("Error: Unable to open inv_data_file for reading.")
		return

	var inv_data_json = JSON.new()

	if inv_data_json.parse(inv_data_file.get_as_text()) != OK:
		print("Error: Failed to parse JSON from inv_data_file.")
		inv_data_file.close()
		return

	inv_data_file.close()
	inv_data = inv_data_json.get_data()


func load_equipment_data():
	var equipment_data_file = FileAccess.open(path_equipment_data_file, FileAccess.READ)
	
	if not equipment_data_file:
		print("Error: Unable to open equipment_data_file for reading.")
		return
	
	var equipment_data_json = JSON.new()
	
	if equipment_data_json.parse(equipment_data_file.get_as_text()) != OK:
		print("Error: Failed to parse JSON from equipment_data_file.")
		equipment_data_file.close()
		return
	
	equipment_data_file.close()
	equipment_data = equipment_data_json.get_data()


func save_inv_data():
	var inv_data_file = FileAccess.open(path_inv_data_file, FileAccess.WRITE)
	
	if not inv_data_file:
		print("Error: Unable to open inv_data_file for writing.")
		return

	var json_string = JSON.stringify(inv_data, "", false)

	inv_data_file.store_string(json_string)
	inv_data_file.close()

func save_equipment_data():
	var equipment_data_file = FileAccess.open(path_equipment_data_file, FileAccess.WRITE)

	if not equipment_data_file:
		print("Error: Unable to open equipment_data_file for writing.")
		return

	var json_string = JSON.stringify(equipment_data)

	equipment_data_file.store_string(json_string)
	equipment_data_file.close()


func get_free_slot():
	for key in inv_data.keys():
		if inv_data[key]["Item"] == null:
			return key
			
	return null
