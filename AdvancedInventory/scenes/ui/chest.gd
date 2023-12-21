extends Control

signal close_chest

var id = 0

@onready var grid_container = get_node("Background/M/V/ScrollContainer/GridContainer")
@onready var drop_item_scene = preload("res://scenes/items/item.tscn")
@onready var character = get_tree().get_first_node_in_group("character")

const icon_path = "res://assets/ui/icon_items/"

var template_chest_slot = preload("res://scenes/ui/templates/chest_slot.tscn")

var items

func _ready():
	id = get_parent().id
	connect("close_chest", Callable(get_parent(), "close_chest"))
	items = GameData.chest_data[str(id)]
	update()

func update():
	for child in grid_container.get_children():
		child.free()
	for key in items.keys():
		var chest_slot_new = template_chest_slot.instantiate()
		if items[key]["Item"] != null:
			var item_name = GameData.item_data[str(items[key]["Item"])]["Name"]
			var icon_texture = load(icon_path + item_name + ".png")
			chest_slot_new.get_node("Icon").set_texture(icon_texture)
			
			var item_stack = items[key]["Stack"]

			if item_stack != null and item_stack > 1:
				chest_slot_new.get_node("Stack").set_text(str(item_stack))
		grid_container.add_child(chest_slot_new, true)

func delete_item(item):
	if GameData.chest_data.has(str(id)):
		if GameData.chest_data[str(id)].has(item):
			GameData.chest_data[str(id)][item]["Item"] = null
			GameData.chest_data[str(id)][item]["Stack"] = null
			
	items[item]["Item"] = null
	items[item]["Stack"] = null

	for key in items.keys():
		if grid_container.has_node(key):
			var chest_slot = grid_container.get_node(key)
			
			if chest_slot == null:
				chest_slot = template_chest_slot.instantiate()
				grid_container.add_child(chest_slot, true)
				chest_slot.name = key

			if items[key]["Item"] != null:
				var item_name = GameData.item_data[str(items[key]["Item"])]["Name"]
				var icon_texture = load(icon_path + item_name + ".png")
				chest_slot.get_node("Icon").set_texture(icon_texture)

				var item_stack = items[key]["Stack"]

				if item_stack != null and item_stack > 1:
					chest_slot.get_node("Stack").set_text(str(item_stack))
			else:
				var icon_texture = null
				chest_slot.get_node("Icon").set_texture(icon_texture)

				var item_stack = ""

				chest_slot.get_node("Stack").set_text(str(item_stack))


func _on_button_pressed():
	visible = false
	emit_signal("close_chest")

func drop_chest_item(slot):
	create_drop_item(slot)
	GameData.chest_data[str(id)][slot]["Item"] = null
	GameData.chest_data[str(id)][slot]["Stack"] = null
	update()
	
func create_drop_item(slot):
	var drop_item_new = drop_item_scene.instantiate()
	drop_item_new.id = items[slot]["Item"]
	drop_item_new.stack = items[slot]["Stack"]
	
	drop_item_new.global_position = character.position + Vector2(randi_range(-40, 40), randi_range(-40, 40))
	character.get_parent().add_child(drop_item_new)
	drop_item_new.visible = true
