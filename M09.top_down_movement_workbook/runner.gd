extends CharacterBody2D

var max_speed := 600.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const RUNNER_DOWN = preload("res://assets/runner_down.png")
const RUNNER_UP = preload("res://assets/runner_up.png")
const RUNNER_RIGHT = preload("res://assets/runner_right.png")
const RUNNER_DOWN_RIGHT = preload("res://assets/runner_down_right.png")
const RUNNER_UP_RIGHT = preload("res://assets/runner_up_right.png") 

const UP_LEFT = Vector2.UP + Vector2.LEFT
const UP_RIGHT = Vector2.UP + Vector2.LEFT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
@onready var skin = $Skin

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction_discrete := direction.sign()
	velocity = direction * max_speed
	move_and_slide()
	if direction_discrete.length() > 0:
		skin.flip_h = direction.x < 0.0
	match direction_discrete:
		Vector2.UP:
			skin.texture = RUNNER_UP
		Vector2.DOWN:
			skin.texture = RUNNER_DOWN
		UP_RIGHT, UP_LEFT:
			skin.texture = RUNNER_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			skin.texture = RUNNER_DOWN_RIGHT
		Vector2.RIGHT, Vector2.LEFT:
			skin.texture = RUNNER_RIGHT

