extends TextureRect

signal delete_item
signal add_item_to_inv
signal drop_chest_item


@onready var tool_tip = preload("res://scenes/ui/templates/tool_tip.tscn")
@onready var item_loot = preload("res://scenes/items/item.tscn")
@onready var split_popup = preload("res://scenes/ui/templates/item_split_popup.tscn")

var chest_id
var chest_node

var is_mouse_entered = false
var is_collected = false
func _ready():
	chest_node = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	chest_id = chest_node.id

	connect("add_item_to_inv", Callable(get_node("/root/SceneHandler/Main/UI/Control/Inventory"), "add_item"))
	connect("drop_chest_item", Callable(chest_node, "drop_chest_item"))
	connect("delete_item", Callable(chest_node, "delete_item"))

func _physics_process(_delta):
	var chest_slot = get_parent().get_name()
	if Input.is_action_pressed("Secondary") and Input.is_action_pressed("RightClick") and is_mouse_entered and !is_collected:
		is_collected = true
		var item : ItemLoot = item_loot.instantiate()
		item.id = GameData.chest_data[str(chest_id)][chest_slot]["Item"]
		item.stack = GameData.chest_data[str(chest_id)][chest_slot]["Stack"]

		if get_node("/root/SceneHandler/Main/UI/Control/Inventory").has_free_slot():
			emit_signal("add_item_to_inv", item)
			GameData.chest_data[str(chest_id)][chest_slot]["Item"] = null
			GameData.chest_data[str(chest_id)][chest_slot]["Stack"] = null
			emit_signal("delete_item", chest_slot)


func _get_drag_data(_pos):
	# Retrieve indormation about the slot we are dragging
	var chest_slot = get_parent().get_name()

	if chest_slot in GameData.chest_data[str(chest_id)] and GameData.chest_data[str(chest_id)][chest_slot]["Item"] != null:
		var data = {}
		data["origin_chest_id"] = str(chest_id)
		data["origin_chest_slot"] = chest_slot
		data["origin_node"] = self
		data["origin_panel"] = "Chest"
		data["origin_item_id"] = GameData.chest_data[str(chest_id)][chest_slot]["Item"]
		data["origin_equipment_slot"] = GameData.item_data[str(GameData.chest_data[str(chest_id)][chest_slot]["Item"])]["EquipmentSlot"]
		data["origin_stackable"] = GameData.item_data[str(GameData.chest_data[str(chest_id)][chest_slot]["Item"])]["Stackable"]
		data["origin_stack"] = GameData.chest_data[str(chest_id)][chest_slot]["Stack"]
		data["origin_texture"] = texture

		
		var drag_texture = TextureRect.new()
		drag_texture.expand_mode = 1
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)

		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		control.z_index = 101
		set_drag_preview(control)
		
		return data

func _can_drop_data(_pos, data):
	# Check is we can drop an item in this slot
	var targer_chest_slot = get_parent().get_name()

	if targer_chest_slot == "ChestDropSlot":
		if data["origin_panel"] == "Chest":
			return true
		else:
			return false
		
	if GameData.chest_data[str(chest_id)][targer_chest_slot]["Item"] == null: # We move an item
		data["target_item_id"] = null
		data["target_texture"] = null
		data["target_stack"] = null
		return true
	else: # We spaw an item
		if Input.is_action_just_pressed("Secondary"):
			return false
		else:
			data["target_item_id"] = GameData.chest_data[str(chest_id)][targer_chest_slot]["Item"]
			data["target_texture"] = texture
			data["target_stack"] = GameData.chest_data[str(chest_id)][targer_chest_slot]["Stack"]

			if data["origin_panel"] == "CharacterSheet":
					return false
			else: #data["original_panel"] == "Inventory" and data["original_panel"] == "Chest":
				return true

func _drop_data(_pos, data):
	var item_split_popup = false
	# What happens when we drop an item in this slot
	var targer_chest_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()

	if targer_chest_slot == "ChestDropSlot":
		print(targer_chest_slot)
		emit_signal("drop_chest_item", origin_slot)
		return
		
	if data["origin_node"] == self:
		pass
	elif Input.is_action_pressed("Secondary") and data["origin_panel"] == "Chest" and data["origin_stack"] > 1:
		item_split_popup = true
		var split_popup_instance = split_popup.instantiate()
		split_popup_instance.position = global_position + Vector2(0, 100)
		split_popup_instance.data = data
		add_child(split_popup_instance)
		get_node("ItemSplitPopup").visible = true
	else:
		# Update the data of the origin
		if data["target_item_id"] == data["origin_item_id"] and data["origin_stackable"] == true and data["origin_panel"] == "Chest":
			GameData.chest_data[str(chest_id)][origin_slot]["Item"] = null
			GameData.chest_data[str(chest_id)][origin_slot]["Stack"] = null
		elif data["origin_panel"] == "Inventory":
			PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
			PlayerData.inv_data[origin_slot]["Stack"] = data["target_stack"]
		elif data["origin_panel"] == "Chest":
			GameData.chest_data[str(chest_id)][origin_slot]["Item"] = data["target_item_id"]
			GameData.chest_data[str(chest_id)][origin_slot]["Stack"] = data["target_stack"]

		# Update the texture and label of the origin
		if data["target_item_id"] == data["origin_item_id"] and data["origin_stackable"] == true:
			data["origin_node"].texture = null
			data["origin_node"].get_node("../Stack").set_text("")
		elif data["origin_panel"] == "CharacterSheet" and data["target_item_id"] == null:
			var default_texture = load("res://assets/ui/character_sheet/inventory_item_" + origin_slot + "_bg_icon.png")
			data["origin_node"].texture = default_texture
		else:
			data["origin_node"].texture = data["target_texture"]
			if data["target_stack"] != null and data["target_stack"] > 1:
				data["origin_node"].get_node("../Stack").set_text(str(data["target_stack"]))
			elif data["origin_panel"] == "Inventory":

				data["origin_node"].get_node("../Stack").set_text("")
			elif data["origin_panel"] == "Chest":
				#GameData.chest_data[str(chest_id)][targer_chest_slot]["Item"] = null
				GameData.chest_data[str(chest_id)][targer_chest_slot]["Stack"] = null
				data["origin_node"].get_node("../Stack").set_text("")
				
		# Update the texture, label and data of the target 
		# "origin_panel": "Inventory"
		if data["target_item_id"] == data["origin_item_id"] and data["origin_stackable"] == true:
			var new_stack = data["target_stack"] + data["origin_stack"]
			GameData.chest_data[str(chest_id)][targer_chest_slot]["Stack"] = new_stack
			get_node("../Stack").set_text(str(new_stack))
			texture = data["origin_texture"]
			PlayerData.inv_data[origin_slot]["Stack"] = 0
		else:
			GameData.chest_data[str(chest_id)][targer_chest_slot]["Item"] = data["origin_item_id"]
			texture = data["origin_texture"]
			GameData.chest_data[str(chest_id)][targer_chest_slot]["Stack"] = data["origin_stack"]
			
			if data["origin_stack"] != null and data["origin_stack"] > 1:
				get_node("../Stack").set_text(str(data["origin_stack"]))
			else:
				get_node("../Stack").set_text("")
	
	is_collected = false
	if !item_split_popup:
		_on_mouse_entered()

func split_stack(split_amount, data):
	var target_chest_slot = get_parent().get_name()
	if GameData.chest_data[str(chest_id)][target_chest_slot]["Item"] == null:
		var origin_slot = data["origin_node"].get_parent().get_name()

		GameData.chest_data[str(chest_id)][origin_slot]["Stack"] = data["origin_stack"] - split_amount
		GameData.chest_data[str(chest_id)][target_chest_slot]["Item"] = data["origin_item_id"]
		GameData.chest_data[str(chest_id)][target_chest_slot]["Stack"] = split_amount
		texture = data["origin_texture"]

		if data["origin_stack"] - split_amount > 1:
			data["origin_node"].get_node("../Stack").set_text(str(data["origin_stack"] - split_amount))
		else:
			data["origin_node"].get_node("../Stack").set_text("")
			
		if split_amount > 1:
			get_node("../Stack").set_text(str(split_amount))
		else:
			get_node("../Stack").set_text("")


func _on_mouse_entered():
	is_mouse_entered = true
	#var tool_tip_instance = tool_tip.instantiate()
	#tool_tip_instance.origin = "Inventory"
	#tool_tip_instance.slot = get_parent().get_name()
	#tool_tip_instance.position = global_position
	#tool_tip_instance.position.x += 100
	#
	#add_child(tool_tip_instance)
	#get_node("ToolTip").visible = false
	#
	#await get_tree().create_timer(1).timeout
#
	#if has_node("ToolTip") and get_node("ToolTip").valid:
		#get_node("ToolTip").visible = true

func _on_mouse_exited():
	is_mouse_entered = false
	#if has_node("ToolTip"):
		#get_node("ToolTip").free()
