extends Area2D


# Called when the node enters the scene tree for the first time.
func ready() -> void:
	area_entered.connect(_on_area_entered)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(_on_area_entered: Area2D) -> void:
	queue_free()

