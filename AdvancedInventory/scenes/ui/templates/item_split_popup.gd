extends Popup

var data

func _ready():
	get_node("N/M/H/Amount").grab_focus()

func _on_confirm_pressed():
	var split_amount = get_node("N/M/H/Amount").get_text()
	if split_amount == "" or int(split_amount) < 1:
		split_amount = 1
	if int(split_amount) >= data["origin_stack"]:
		split_amount = data["origin_stack"] - 1
	get_parent().split_stack(int(split_amount), data)
	queue_free()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_confirm_pressed()
