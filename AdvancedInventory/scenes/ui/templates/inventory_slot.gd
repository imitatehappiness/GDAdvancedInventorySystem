extends TextureRect
signal update_character_stats

@onready var inventory = get_tree().get_first_node_in_group("inventory")

signal drop_item

@onready var tool_tip = preload("res://scenes/ui/templates/tool_tip.tscn")
@onready var split_popup = preload("res://scenes/ui/templates/item_split_popup.tscn")

func _ready():
	connect("drop_item", Callable(get_node("/root/SceneHandler/Main/UI/Control/Inventory"), "drop_item"))
	connect("update_character_stats", Callable(get_node("/root/SceneHandler/Main"), "set_character_stats"))

func _get_drag_data(_pos):
	# Retrieve indormation about the slot we are dragging
	var inv_slot = get_parent().get_name()

	if inv_slot in PlayerData.inv_data and PlayerData.inv_data[inv_slot]["Item"] != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "Inventory"
		data["origin_item_id"] = PlayerData.inv_data[inv_slot]["Item"]
		data["origin_equipment_slot"] = GameData.item_data[str(PlayerData.inv_data[inv_slot]["Item"])]["EquipmentSlot"]
		data["origin_stackable"] = GameData.item_data[str(PlayerData.inv_data[inv_slot]["Item"])]["Stackable"]
		data["origin_stack"] = PlayerData.inv_data[inv_slot]["Stack"]
		data["origin_texture"] = texture
		
		var drag_texture = TextureRect.new()
		drag_texture.expand_mode = 1
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		return data

func _can_drop_data(_pos, data):
	# Check is we can drop an item in this slot
	var targer_inv_slot = get_parent().get_name()

	if targer_inv_slot == "DropSlot":
		if data["origin_panel"] == "Inventory":
			return true
		else:
			return false

	if PlayerData.inv_data[targer_inv_slot]["Item"] == null: # We move an item
		data["target_item_id"] = null
		data["target_texture"] = null
		data["target_stack"] = null
		return true
	else: # We spaw an item
		if Input.is_action_just_pressed("Secondary"):
			return false
		else:
			data["target_item_id"] = PlayerData.inv_data[targer_inv_slot]["Item"]
			data["target_texture"] = texture
			data["target_stack"] = PlayerData.inv_data[targer_inv_slot]["Stack"]

			if data["origin_panel"] == "CharacterSheet":
				var targer_equipment_slot = GameData.item_data[str(PlayerData.inv_data[targer_inv_slot]["Item"])]["EquipmentSlot"]
				if targer_equipment_slot == data["origin_equipment_slot"]:
					return true
				else:
					return false
			else: #data["original_panel"] == "Inventory": # data["original_panel"] == "Chest"
				return true

func _drop_data(_pos, data):
	var item_split_popup = false
	# What happens when we drop an item in this slot
	var targer_inv_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	if targer_inv_slot == "DropSlot":
		emit_signal("drop_item", origin_slot)
		return
	if data["origin_node"] == self:
		pass
	elif Input.is_action_pressed("Secondary") and data["origin_panel"] == "Inventory" and data["origin_stack"] > 1:
		item_split_popup = true
		var split_popup_instance = split_popup.instantiate()
		split_popup_instance.position = global_position + Vector2(0, 100)
		split_popup_instance.data = data
		add_child(split_popup_instance)
		get_node("ItemSplitPopup").visible = true
	else:
		# Update the data of the origin
		if data["target_item_id"] == data["origin_item_id"] and data["origin_stackable"] == true and data["origin_panel"] == "Inventory":
			PlayerData.inv_data[origin_slot]["Item"] = null
			PlayerData.inv_data[origin_slot]["Stack"] = null
		elif data["origin_panel"] == "Inventory":
			PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
			PlayerData.inv_data[origin_slot]["Stack"] = data["target_stack"]
		elif data["origin_panel"] == "CharacterSheet":
			PlayerData.equipment_data[origin_slot] = data["target_item_id"]
		elif data["origin_panel"] == "Chest":
			GameData.chest_data[data["origin_chest_id"]][origin_slot]["Item"] = data["target_item_id"]
			GameData.chest_data[data["origin_chest_id"]][origin_slot]["Stack"] = data["target_stack"]

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
				data["origin_node"].get_node("../Stack").set_text("")
				
		# Update the texture, label and data of the target 
		if data["target_item_id"] == data["origin_item_id"] and data["origin_stackable"] == true:
			var new_stack = data["target_stack"] + data["origin_stack"]
			PlayerData.inv_data[targer_inv_slot]["Stack"] = new_stack
			get_node("../Stack").set_text(str(new_stack))
			texture = data["origin_texture"]
			if data["origin_panel"] == "Chest":
				GameData.chest_data[data["origin_chest_id"]][origin_slot]["Stack"] = 0
		else:
			PlayerData.inv_data[targer_inv_slot]["Item"] = data["origin_item_id"]
			texture = data["origin_texture"]
			PlayerData.inv_data[targer_inv_slot]["Stack"] = data["origin_stack"]
			if data["origin_stack"] != null and data["origin_stack"] > 1:
				get_node("../Stack").set_text(str(data["origin_stack"]))
			else:
				get_node("../Stack").set_text("")

	if !item_split_popup:
		_on_mouse_entered()
	emit_signal("update_character_stats")

func split_stack(split_amount, data):
	var target_inv_slot = get_parent().get_name()
	if PlayerData.inv_data[target_inv_slot]["Item"] == null:
		var origin_slot = data["origin_node"].get_parent().get_name()
		
		PlayerData.inv_data[origin_slot]["Stack"] = data["origin_stack"] - split_amount
		PlayerData.inv_data[target_inv_slot]["Item"] = data["origin_item_id"]
		PlayerData.inv_data[target_inv_slot]["Stack"] = split_amount
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
	var tool_tip_instance = tool_tip.instantiate()
	tool_tip_instance.origin = "Inventory"
	tool_tip_instance.slot = get_parent().get_name()
	tool_tip_instance.position = global_position
	tool_tip_instance.position.x += 150
	
	add_child(tool_tip_instance)
	get_node("ToolTip").visible = false
	
	await get_tree().create_timer(1).timeout

	if has_node("ToolTip") and get_node("ToolTip").valid:
		get_node("ToolTip").visible = true

func _on_mouse_exited():
	if has_node("ToolTip"):
		get_node("ToolTip").free()

