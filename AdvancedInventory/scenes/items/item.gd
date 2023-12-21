extends Area2D
class_name ItemLoot

signal get_item

@export var id = 10001:
	set(value):
		id = value
		
@export var stack = 2:
	set(value):
		stack = value

@onready var inventory = get_tree().get_first_node_in_group("inventory")

var can_take = false

func _ready():
	z_index = 0
	var item_name = GameData.item_data[str(id)]["Name"]
	var stackable = GameData.item_data[str(id)]["Stackable"]
	if !stackable:
		stack = 1
	$Sprite2D.texture = load("res://assets/ui/icon_items/" + item_name + ".png")
	if stack > 1:
		$Stack.text = str(stack)
	else:
		$Stack.text = str("")
	connect("get_item", Callable(get_node("/root/SceneHandler/Main/UI/Control/Inventory"), "add_item"))

func _physics_process(_delta):
	if can_take:
		if Input.is_action_pressed("Collect"):
			emit_signal("get_item", self)

func _on_body_entered(_body):
	can_take = true
	$CollectLabel.visible = true
	
func _on_body_exited(_body):
	can_take = false
	$CollectLabel.visible = false

func free_item():
	queue_free()

func set_id(value):
	id = value
	
func set_stack(value):
	stack = value
