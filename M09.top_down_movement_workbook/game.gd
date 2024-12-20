extends Node2D

@onready var bouncer = %Bouncer
@onready var runner = $Runner
@onready var count_down = %CountDown
@onready var finish_line = %FinishLine

# Called when the node enters the scene tree for the first time.
func _ready():
	finish_line.body_entered.connect(func (body: Node) -> void:
		if not body is Runner:
			return
		var runner := body as Runner

		runner.set_physics_process(false)
		var destination_position: Vector2 = (
			finish_line.global_position
			+ Vector2(0, 64)
		)

		runner.walk_to(destination_position)
		runner.walked_to.connect(
			finish_line.pop_confettis
		)
	)
	count_down.start_counting()
	runner.set_physics_process(false)
	count_down.counting_finished.connect(
		func() -> void:
			runner.set_physics_process(true)
	)
	finish_line.confettis_finished.connect(
		get_tree().reload_current_scene
	)
	bouncer.set_physics_process(false)

	count_down.counting_finished.connect(
		func() -> void:
			bouncer.set_physics_process(true)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
