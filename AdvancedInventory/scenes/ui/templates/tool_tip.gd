extends Popup

var origin = ""
var slot = ""
var valid  = false
var chest_id = 0

func _ready():
	var item_id
	if origin == "Inventory":
		if slot in PlayerData.inv_data:
			if PlayerData.inv_data[slot]["Item"] != null:
				item_id = str(PlayerData.inv_data[slot]["Item"])
				valid = true
	elif origin == "CharacterSheet":
		if PlayerData.equipment_data[slot] != null:
			item_id = str(PlayerData.equipment_data[slot])
			valid = true
	elif origin == "Chest":
		if GameData.chest_data[str(chest_id)][slot] != null:
			item_id = str(GameData.chest_data[str(chest_id)][slot]["Item"])
			valid = true
			if GameData.chest_data[str(chest_id)][slot]["Item"] == null:
				valid = false

			
	if valid:
		get_node("N/M/V/ItemName").set_text(GameData.item_data[item_id]["Name"])
		var item_stat = 1
		for i in range(GameData.item_stats.size()):
			var stat_name = GameData.item_stats[i];
			var item_label = GameData.item_stats_label[i];
			if GameData.item_data[item_id][stat_name] != null:
				var stat_value = GameData.item_data[item_id][stat_name]
				get_node("N/M/V/Stat" + str(item_stat) + "/Stat").set_text(item_label + ": " + str(stat_value))
				
				if GameData.item_data[item_id]["EquipmentSlot"] != null and (origin == "Inventory" or origin == "Chest"):
					var stat_difference = compare_items(item_id, stat_name, stat_value)
					get_node("N/M/V/Stat" + str(item_stat) + "/Difference").set_text(" " + str(stat_difference))
					if stat_difference > 0:
						get_node("N/M/V/Stat" + str(item_stat) + "/Difference").set("modulate", Color("3eff00"))
					elif stat_difference < 0:
						get_node("N/M/V/Stat" + str(item_stat) + "/Difference").set("modulate", Color("ff0000"))

					get_node("N/M/V/Stat" + str(item_stat) + "/Difference").show()
				item_stat += 1


func compare_items(item_id, stat_name, stat_value):
	var stat_difference
	var equipment_slot = GameData.item_data[item_id]["EquipmentSlot"]
	if PlayerData.equipment_data[equipment_slot] != null:
		var item_id_current = PlayerData.equipment_data[equipment_slot]
		var stat_value_current = GameData.item_data[str(item_id_current)][stat_name]
		stat_difference = stat_value - stat_value_current
	else:
		stat_difference = stat_value
	return stat_difference
