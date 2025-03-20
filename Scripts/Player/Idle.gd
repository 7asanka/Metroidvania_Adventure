extends State
class_name IdleState

func enter():
	object.velocity.x = 0  # Stop horizontal movement
	object.anim.play("Idle")  # Ensure idle animation plays

func physics_update(_delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		change_state("Running")  # Switch to movement
	elif Input.is_action_just_pressed("jump"):
		change_state("Jump")  # Switch to jumping
	elif Input.is_action_just_pressed("melle_attack"):
		change_state("MAttack")
	
	if object.velocity.y > 0:
		change_state("Fall")
