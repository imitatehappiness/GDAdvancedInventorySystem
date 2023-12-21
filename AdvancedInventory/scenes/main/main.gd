extends Node2D

@onready var character_stats = $UI/Control/CharacterStats

func _ready():
	set_character_stats()

func _on_save_button_pressed():
	PlayerData.save_inv_data()
	PlayerData.save_equipment_data()
	
	GameData.save_chest_data()
	
func set_character_stats():
	var stats = {
		"Attack": 0,
		"Defense": 0,
		"Health": 0,
		"Mana": 0,
	}
	for key in PlayerData.equipment_data.keys():
		if PlayerData.equipment_data[key] != null:
			for stat in stats.keys():
				if GameData.item_data[str(PlayerData.equipment_data[key])][stat] != null:
					stats[stat] += GameData.item_data[str(PlayerData.equipment_data[key])][stat]
	
	character_stats.text = "Stats: \n"
	for key in stats.keys():
		character_stats.text += key + ": " + str(stats[key]) + "\n"
		
