extends State
class_name MushHurt

const HURT_DURATION = 0.5  # Time before returning to patrol
var timer = 0

func enter():
	object.velocity = Vector2.ZERO  # Stop movement
	object.mush_anim.play("MushHurt")  # Play hurt animation (if exists)
	print("Hurt state entered")
	timer = HURT_DURATION

func update(delta):
	timer -= delta
	if timer <= 0:
		change_state("MushPatrol")  # Return to patrol

func physics_update(delta):
	object.move_and_slide()
