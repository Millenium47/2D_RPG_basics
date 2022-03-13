extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var speed = 100.0

func _physics_process(delta):
	move_and_slide(_get_velocity())	

func _get_velocity():
	return _get_direction() * speed
	
func _get_direction():
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	return direction
