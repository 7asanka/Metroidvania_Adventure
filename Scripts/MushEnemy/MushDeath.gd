extends State
class_name MushDeath

func enter():
	object.hitbox.disabled = true
	object.velocity  = Vector2.ZERO
	object.mush_anim.play("Death")
	await object.mush_anim.animation_finished
	object.queue_free()
