extends State
class_name runState

const SPEED = 100  # Adjust as needed

func enter():
	object.anim.play("Run")  # Play running animation

func physics_update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0 :	
		object.get_node("AnimatedSprite2D").flip_h = true
		object.swordHitbox.position = Vector2(-19.5, -15)
	elif direction > 0:
		object.get_node("AnimatedSprite2D").flip_h = false
		object.swordHitbox.position = Vector2(19.5, -15)
	elif direction == 0:
		change_state("Idle")  # Go back to idle if no input
		return

	object.velocity.x = direction * SPEED
	# Get floor (platform) velocity if standing on one
	var platform_velocity = object.get_platform_velocity()
	 # Adjust for moving platforms
	object.velocity.x -= platform_velocity.x  # Neutralize platform effect
	
	object.move_and_slide()
	
	if object.velocity.y > 0:
		change_state("Fall")

	if Input.is_action_just_pressed("jump"):
		change_state("Jump")  # Switch to jumping
