extends State
class_name HurtState

func enter():
	object.velocity = Vector2.ZERO
	object.anim.play("Hurt")
	print(object.health)
	await object.anim.animation_finished
	change_state("Idle")
