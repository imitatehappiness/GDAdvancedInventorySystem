extends Area2D

@export var id = 0
@onready var character = get_tree().get_first_node_in_group("character")

var can_open: bool = false

func _ready():
	$Chest.id = id
	$Chest.z_index = 100

func _physics_process(_delta):
	if can_open:
		if Input.is_action_pressed("Action") and can_open:
			can_open = false
			$CollectLabel.visible = false
			$Sprite2D.frame = 2
			$Chest.visible = !$Chest.visible
			var screen_size = character.get_viewport_rect().size

			$Chest.global_position.x = screen_size.x - 570
			$Chest.global_position.y = -screen_size.y + 1083


func _on_body_entered(_body):
	can_open = true
	$CollectLabel.visible = true
	
func _on_body_exited(_body):
	$Sprite2D.frame = 0
	can_open = false
	$CollectLabel.visible = false
	$Chest.visible = false
	
func close_chest():
	$Sprite2D.frame = 0
	can_open = true
	$CollectLabel.visible = true
