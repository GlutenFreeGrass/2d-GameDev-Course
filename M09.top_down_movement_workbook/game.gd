extends Node2D

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

	finish_line.confettis_finished.connect(
		get_tree().reload_current_scene
	)
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
