extends Area2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area_that_enetered: Area2D) -> void:
	queue_free()
