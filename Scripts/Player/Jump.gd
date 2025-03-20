extends State
class_name JumpState

const JUMP_FORCE = -450  
const AIR_ACCELERATION = 600  
const MAX_AIR_SPEED = 100  

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")  

func enter():
	if object.is_on_floor():
		object.velocity.y = JUMP_FORCE  # Normal jump
		object.has_double_jumped = false  # Reset double jump
		object.anim.play("Jump")
	elif object.can_double_jump and not object.has_double_jumped:
		object.velocity.y = JUMP_FORCE  # Apply second jump
		object.has_double_jumped = true  # Mark double jump as used
		object.anim.play("DoubleJump")  # Play double jump animation

func physics_update(delta):
	object.velocity.y += GRAVITY * delta
	
	if not object.is_on_floor() and not object.has_double_jumped:
		if Input.is_action_just_pressed("jump"):
			change_state("Jump")
	
	var platform_velocity = object.get_platform_velocity()
	 # Adjust for moving platforms
	object.velocity.x -= platform_velocity.x  # Neutralize platform effect
	
	var direction = Input.get_axis("move_left", "move_right")
	object.velocity.x = move_toward(object.velocity.x, direction * MAX_AIR_SPEED, AIR_ACCELERATION * delta)
	object.move_and_slide()

	if object.velocity.y > 0:  
		change_state("Fall")
