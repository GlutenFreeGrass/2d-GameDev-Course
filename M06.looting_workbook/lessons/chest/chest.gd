extends Area2D

@export var possible_items: Array[PackedScene] = []
@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer 


func open() -> void:
	animation_player.play("open")
	input_pickable = false
	if possible_items.is_empty():
		return
	for current_index in range(randi_range(1, 3)):
		_spawn_random_item()
	
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	canvas_group.material.set_shader_parameter("line_thickness", 5.0)

func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 5.0, 10.0, 0.08)
	

func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 10.0, 5.0, 0.08)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)
	
func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	var event_is_mouse_click: bool = (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed())
	if event_is_mouse_click:
		open()
	
func _spawn_random_item() -> void:
	var loot_item: Area2D = possible_items.pick_random().instantiate()
	add_child(loot_item)
	var random_angle := randf_range(0.0, 2.0 * PI)
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	var random_distance := randf_range(60.0, 120.0)
	var land_position := random_direction * random_distance
	
	const FLIGHT_TIME := 1.0
	const HALF_FLIGHT_TIME := FLIGHT_TIME / 2.0
	
	var tween := create_tween()
	tween.set_parallel()
	loot_item.scale = Vector2(0.25, 0.25)
	tween.tween_property(loot_item, "scale", Vector2(1.0, 1.0), HALF_FLIGHT_TIME)
	tween.tween_property(loot_item, "position:x", land_position.x, FLIGHT_TIME)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	var jump_height := randf_range(30.0, 80.0)
	tween.tween_property(loot_item, "position:y", land_position.y - jump_height, HALF_FLIGHT_TIME)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(loot_item, "position:y", land_position.y, HALF_FLIGHT_TIME)
	
