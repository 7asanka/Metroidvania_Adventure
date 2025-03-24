extends State
class_name BFlyDeath

var already_dead = false  

@onready var hit_box = $"../../HitBox"

func enter():
	if already_dead:  
		return
	already_dead = true
	
	print("Fly entered death state")
	hit_box.visible = false
	object.velocity = Vector2.ZERO
	object.anim.play("BFlyDeath")
	await object.anim.animation_finished
	
	print("Fly should be removed now")
	object.queue_free()  
