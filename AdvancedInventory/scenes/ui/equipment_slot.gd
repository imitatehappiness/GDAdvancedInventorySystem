extends TextureRect

signal update_character_stats

@onready var tool_tip = preload("res://scenes/ui/templates/tool_tip.tscn")

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("update_character_stats", Callable(get_node("/root/SceneHandler/Main"), "set_character_stats"))
	
func _get_drag_data(_pos):
	# Retrieve indormation about the slot we are dragging
	var equipment_slot = get_parent().get_name()
	if PlayerData.equipment_data[equipment_slot] != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "CharacterSheet"
		data["origin_item_id"] = PlayerData.equipment_data[equipment_slot]
		data["origin_equipment_slot"] = equipment_slot
		data["origin_texture"] = texture
		data["origin_stack"] = 1
		data["origin_stackable"] = false

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
	if has_node("ToolTip"):
		get_node("ToolTip").free()
	# Check is we can drop an item in this slot
	var targer_equipment_slot = get_parent().get_name()
	if targer_equipment_slot == data["origin_equipment_slot"]:
		if PlayerData.equipment_data[targer_equipment_slot] == null:
			data["target_item_id"] = null
			data["target_texture"] = null
		else:
			data["target_item_id"] = PlayerData.equipment_data[targer_equipment_slot]
			data["target_texture"] = texture
		return true
	else:
		return false

func _drop_data(_pos, data):
	# What happens when we drop an item in this slot
	var targer_equipment_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	# Update the data of the origin
	if data["origin_panel"] == "Inventory":
		PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
	else: # CharacterSheet
		PlayerData.equipment_data[origin_slot] = data["target_item_id"]
		
	# Update the texture of the origin
	if data["origin_panel"] == "CharacterSheet" and data["target_item_id"] == null:
		var default_texture = load("res://assets/ui/character_sheet/inventory_item_" + origin_slot + "_bg_icon.png")
		data["origin_node"].texture = default_texture
	else:
		data["origin_node"].texture = data["target_texture"]
		
	PlayerData.equipment_data[targer_equipment_slot] = data["origin_item_id"]
	texture = data["origin_texture"]
	
	emit_signal("update_character_stats")
	_on_mouse_entered()

func _on_mouse_entered():
	var tool_tip_instance = tool_tip.instantiate()
	tool_tip_instance.origin = "CharacterSheet"
	tool_tip_instance.slot = get_parent().get_name()
	tool_tip_instance.position = global_position
	tool_tip_instance.position.x += 150
	
	add_child(tool_tip_instance)
	get_node("ToolTip").visible = false
	
	await get_tree().create_timer(0.8).timeout

	if has_node("ToolTip") and get_node("ToolTip").valid:
		get_node("ToolTip").visible = true

func _on_mouse_exited():
	if has_node("ToolTip"):
		get_node("ToolTip").free()
