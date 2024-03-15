extends Sprite2D

var max_speed := 600.0
var velocity := Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Vector2(0,0)
	direction.x = Input.get_axis("move_left" , "move_right")
	direction.y = Input.get_axis("move_up" , "move_down")
	
	if direction.length() > 1:
		direction = direction.normalized()
	
	velocity = direction * max_speed
	position += velocity * delta
	rotation = velocity.angle()
