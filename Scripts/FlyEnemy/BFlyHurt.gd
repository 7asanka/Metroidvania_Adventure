extends State
class_name BFlyHurt

const HURT_DURATION = 0.3  
var timer = 0

func enter():
	object.anim.play("BFlyHurt")
	await object.anim.animation_finished

func update(delta):
	timer -= delta
	if object.health <= 0:
		print("Fly is at 0 HP, switching to death state.")
		await object.anim.animation_finished
		change_state("BFlyDeath")
	elif timer <= 0:
		change_state("BFlyPatrol")  

func exit():
	object.taking_damage = false
