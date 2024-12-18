class_name Runner 

extends CharacterBody2D

signal walked_to 
@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@onready var runner_visual_red = %RunnerVisualRed
@onready var dust = $Dust





# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
	if direction.length() > 0.0: 
		var current_speed_percent := velocity.length() / max_speed
		runner_visual_red.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
		runner_visual_red.angle = rotate_toward(runner_visual_red.angle, direction.orthogonal().angle(), 8.0 * delta)
		runner_visual_red.animation_name = RunnerVisual.Animations.WALK
		dust.emitting = true
	else:
		runner_visual_red.animation_name = RunnerVisual.Animations.IDLE
		dust.emitting = false

func walk_to(destination_global_position: Vector2) -> void:
	# obtain the direction and angle
	var direction := global_position.direction_to(destination_global_position)
	runner_visual_red.angle = direction.orthogonal().angle()

	# Set the proper animation name
	runner_visual_red.animation_name = RunnerVisual.Animations.WALK
	dust.emitting = true

	# obtain distance, and calculate direction from that
	var distance := global_position.distance_to(destination_global_position)
	var duration :=  distance / (max_speed * 0.2)

	# tween the runner to destination, then emit `walked_to`
	var tween := create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func():
		runner_visual_red.animation_name = RunnerVisual.Animations.IDLE
		dust.emitting = false
		walked_to.emit()
	)
