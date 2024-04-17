extends Area2D


# Called when the node enters the scene tree for the first time.
func ready() -> void:
	area_entered.connect(_on_area_entered)
	play_floating_animation()
	
func _process(delta):
	pass
	
func _on_area_entered(area_that_entered: Area2D) -> void:
	queue_free()

func play_floating_animation() -> void:
	var tween := create_tween()
	var sprite_2d := get_node("Sprite2D")
	var position_offset := Vector2(0.0, 4.0)
	#updated duration variable
	var duration := randf_range(0.8, 1.2)
	#sprite_2d.position.y = -1.0 * position_offset.y
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite_2d, "position", position_offset, duration)
	tween.tween_property(sprite_2d, "position", -1.0 * position_offset, duration)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.


