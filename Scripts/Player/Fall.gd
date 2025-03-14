extends State
class_name FallState

const AIR_ACCELERATION = 600
const MAX_AIR_SPEED = 150

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")  # Must match FallState and Player.gd

func enter():
	object.anim.play("Fall")

func physics_update(delta):
	object.velocity.y += GRAVITY * delta  # Apply gravity

	# Smooth air movement
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1

	object.velocity.x = move_toward(object.velocity.x, direction * MAX_AIR_SPEED, AIR_ACCELERATION * delta)
	object.move_and_slide()

	# Transition to Idle or Move when landing
	if object.is_on_floor():
		if direction == 0:
			change_state("Idle")
		else:
			change_state("Running")
