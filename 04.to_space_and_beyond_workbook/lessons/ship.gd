extends Sprite2D

var normal_speed := 600.0
var max_speed := 600.0
var velocity := Vector2(0, 0)
var boost_speed := 1500.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Vector2(0,0)
	direction.x = Input.get_axis("move_left" , "move_right")
	direction.y = Input.get_axis("move_up" , "move_down")
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()
	
	if direction.length() > 1:
		direction = direction.normalized()
	
	velocity = direction * max_speed
	position += velocity * delta
	rotation = velocity.angle()


func _on_timer_timeout():
	max_speed = normal_speed
