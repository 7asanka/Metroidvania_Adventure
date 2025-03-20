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
	var direction = Input.get_axis("move_left", "move_right")
	if direction < 0 :	
		object.get_node("AnimatedSprite2D").flip_h = true
		object.swordHitbox.position = Vector2(-19.5, -15)
	elif direction > 0:
		object.get_node("AnimatedSprite2D").flip_h = false
		object.swordHitbox.position = Vector2(19.5, -15)
		
	object.velocity.x = move_toward(object.velocity.x, direction * MAX_AIR_SPEED, AIR_ACCELERATION * delta)
	object.move_and_slide()

	# Transition to Idle or Move when landing
	if object.is_on_floor():
		if direction == 0:
			change_state("Idle")
		else:
			change_state("Running")
	
	if Input.is_action_just_pressed("jump") and object.has_double_jumped == false and object.can_double_jump:
		change_state("Jump")
		
	if object.is_on_floor():
		object.has_double_jumped = false
