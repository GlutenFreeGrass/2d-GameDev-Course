extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var bird = $Sparrow
@onready var shadow = $Shadow
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = randf_range(1.0, 3.0)
	timer.one_shot = true
	timer.timeout.connect(random_landing_pad)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func random_landing_pad() -> void:
	var random_angle := randf_range(0.0, 2.0 * PI)
	var random_direction := Vector2(1.5, 0.0).rotated(random_angle)
	var random_distance := randf_range(60.0, 120.0)
	var land_position := random_direction * random_distance
	
	const HOP_TIME := 1.5
	const HALF_HOP_TIME := HOP_TIME / 2.0
	
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(bird, "position:x", land_position.x, HOP_TIME)
	tween.tween_property(shadow, "position", land_position, HOP_TIME)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	const JUMP_HEIGHT = 16.0
	tween.tween_property(bird, "position:y", land_position.y - JUMP_HEIGHT, HALF_HOP_TIME)
	
