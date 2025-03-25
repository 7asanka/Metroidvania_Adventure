extends State
class_name MushDeath

@onready var collision_shape_2d = $"../../HurtBox/CollisionShape2D"

func enter():
	object.hitbox.disabled = true
	collision_shape_2d.disabled = true
	object.velocity  = Vector2.ZERO
	object.mush_anim.play("Death")
	await object.mush_anim.animation_finished
	object.queue_free()
