extends State
class_name JumpState

const JUMP_FORCE = -450  # Adjust for a good jump height
const AIR_ACCELERATION = 600  # How fast the player accelerates mid-air
const MAX_AIR_SPEED = 100  # Limit air movement speed

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")  # Must match FallState and Player.gd

func enter():
	object.velocity.y = JUMP_FORCE  # Apply jump force
	object.anim.play("Jump")  # Play jump animation

func physics_update(delta):
	object.velocity.y += GRAVITY * delta  # Apply gravity

	# Apply air acceleration for smoother control
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1

	object.velocity.x = move_toward(object.velocity.x, direction * MAX_AIR_SPEED, AIR_ACCELERATION * delta)
	object.move_and_slide()

	# Transition to FallState when the player starts falling
	if object.velocity.y > 0:
		change_state("Fall")
