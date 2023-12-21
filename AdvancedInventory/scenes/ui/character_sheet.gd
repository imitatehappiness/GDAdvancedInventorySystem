extends Control

@onready var left = get_node("Background/V/Main/LeftEquip")
@onready var middle = get_node("Background/V/Main/Middle")
@onready var right = get_node("Background/V/Main/RightEquip")

const icon_path = "res://assets/ui/icon_items/"

var equipment_item_node = {
	"Head" : "Background/V/Main/LeftEquip/Head/Icon",
	"Neck" : "Background/V/Main/LeftEquip/Neck/Icon",
	"Chest" : "Background/V/Main/LeftEquip/Chest/Icon",
	"Legs" : "Background/V/Main/LeftEquip/Legs/Icon",
	"Feet" : "Background/V/Main/LeftEquip/Feet/Icon",
	
	"MainHand" : "Background/V/Main/Middle/MiddleEquip/MainHand/Icon",
	"OffHand" : "Background/V/Main/Middle/MiddleEquip/OffHand/Icon",
	
	"Back" : "Background/V/Main/RightEquip/Back/Icon",
	"Shoulders" : "Background/V/Main/RightEquip/Shoulders/Icon",
	"Wrists" : "Background/V/Main/RightEquip/Wrists/Icon",
	"Hands" : "Background/V/Main/RightEquip/Hands/Icon",
	"Finger" : "Background/V/Main/RightEquip/Finger/Icon",
}

func _ready():
	for key in PlayerData.equipment_data.keys():
		if PlayerData.equipment_data[key] != null:
			var item_name = GameData.item_data[str(PlayerData.equipment_data[key])]["Name"]
			var equipment_slot = GameData.item_data[str(PlayerData.equipment_data[key])]["EquipmentSlot"]
			var icon_texture = load(icon_path + item_name + ".png")
			get_node(equipment_item_node[equipment_slot]).texture = icon_texture
