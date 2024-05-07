extends Area2D

@onready var flame: Sprite2D = $Flame

func _ready() -> void:
	# This parameter of the shader material gives each flame a slightly different look and randomized animation.
	flame.material.set("shader_parameter/offset", global_position * 0.1)

func toggle_target_node_visibility() -> void: 
	flame.visible = not flame.visible

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	var event_is_mouse_click: bool = (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed())
	if event_is_mouse_click:
		toggle_target_node_visibility()
		
		

