extends KinematicBody2D

const ACCELERATION = 10.0
const MAX_SPEED = 100.0
const MAX_ROLL_SPEED = 120.0
const FRICTION = 10.0

enum {
	MOVE, 
	ROLL, 
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var roll_direction = Vector2.LEFT

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		
func attack_state():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	animationState.travel("Attack")
	_move()
	
func roll_state():
	velocity = roll_direction * MAX_ROLL_SPEED
	animationState.travel("Roll")
	_move()
	
func move_state():
	velocity = move_and_slide(_get_velocity())	
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func _get_velocity():
	direction = _get_direction()
	if direction != Vector2.ZERO:
		roll_direction = direction
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		animationTree.set("parameters/Idle/blend_position", velocity)
		animationTree.set("parameters/Run/blend_position", velocity)
		animationTree.set("parameters/Attack/blend_position", velocity)
		animationTree.set("parameters/Roll/blend_position", velocity)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		
	return velocity
	
func _get_direction():
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	return direction

func _move():
	velocity = move_and_slide(velocity)

func _attack_animation_finished():
	state = MOVE

func _roll_animation_finished():
	velocity = velocity / 2
	state = MOVE
