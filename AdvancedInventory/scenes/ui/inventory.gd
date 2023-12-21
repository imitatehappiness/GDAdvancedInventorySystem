extends Control

@onready var character = get_tree().get_first_node_in_group("character")
@onready var drop_item_scene = preload("res://scenes/items/item.tscn")

@onready var grid_container = get_node("Background/M/V/ScrollContainer/GridContainer")

const icon_path = "res://assets/ui/icon_items/"

var template_inv_slot = preload("res://scenes/ui/templates/inventory_slot.tscn")

func _ready():
	update()

func update():
	for child in grid_container.get_children():
		child.free()

	for key in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instantiate()
		if PlayerData.inv_data[key]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.inv_data[key]["Item"])]["Name"]
			var icon_texture = load(icon_path + item_name + ".png")
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
			
			var item_stack = PlayerData.inv_data[key]["Stack"]

			if item_stack != null and item_stack > 1:
				inv_slot_new.get_node("Stack").set_text(str(item_stack))
			
		grid_container.add_child(inv_slot_new, true)
		
func add_item(item: ItemLoot):

	if !GameData.item_data[str(item.id)]["Stackable"]:
		var slot = PlayerData.get_free_slot()
		if slot != null:
			PlayerData.inv_data[slot]["Item"] = item.id
			PlayerData.inv_data[slot]["Stack"] = item.stack
			item.free_item()
			
	else:
		var insert = false
		for key in PlayerData.inv_data.keys():
			if str(PlayerData.inv_data[key]["Item"]) == str(item.id):
				PlayerData.inv_data[key]["Stack"] += item.stack
				insert = true
				item.free_item()
				break
		if !insert:
			var slot = PlayerData.get_free_slot()
			if slot != null:
				PlayerData.inv_data[slot]["Item"] = item.id
				PlayerData.inv_data[slot]["Stack"] = item.stack
				item.free_item()
	update()

func drop_item(slot):
	create_drop_item(slot)
	PlayerData.inv_data[slot]["Item"] = null
	PlayerData.inv_data[slot]["Stack"] = null
	update()
	
func create_drop_item(slot):
	var drop_item_new = drop_item_scene.instantiate()

	drop_item_new.id = PlayerData.inv_data[slot]["Item"]
	drop_item_new.stack = PlayerData.inv_data[slot]["Stack"]
	
	drop_item_new.global_position = character.position + Vector2(randi_range(-40, 40), randi_range(-40, 40))
	character.get_parent().add_child(drop_item_new)
	drop_item_new.visible = true

func has_free_slot():
	for key in PlayerData.inv_data.keys():
		if PlayerData.inv_data[key]["Item"] == null:
			return true
	return false
