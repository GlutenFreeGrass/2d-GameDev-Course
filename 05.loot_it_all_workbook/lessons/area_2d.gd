extends Area2D


# Called when the node enters the scene tree for the first time.
func ready():
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	queue_free()

