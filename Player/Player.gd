extends KinematicBody2D

const ACCELERATION = 10.0
const MAX_SPEED = 100.0
const FRICTION = 10.0

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

func _physics_process(delta):
	velocity = move_and_slide(_get_velocity())	

func _get_velocity():
	direction = _get_direction()
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		
	return velocity
	
func _get_direction():
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	return direction
