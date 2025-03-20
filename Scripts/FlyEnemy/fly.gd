extends CharacterBody2D

var health = 2
var max_health = 2
var direction
var player
var chasing = false

@onready var b_fly_anim = $AnimationPlayer
@onready var b_fly_sprite = $AnimatedSprite2D
@onready var b_fly_fsm = $BFlyFSM

func _ready():
	b_fly_fsm.change_state("BFlyPatrol")
	
func _process(delta):
	b_fly_fsm.update(delta)
	
	if health <= 0:
		queue_free()
		
	if velocity.x > 0:
		b_fly_sprite.flip_h = true
	elif velocity.x < 0:
		b_fly_sprite.flip_h = false
	
func _physics_process(delta):
	b_fly_fsm.physics_update(delta)
	move_and_slide()

func take_damage(damage):
	health -= damage
	
func reset():
	b_fly_fsm.change_state("BFlyPatrol")
	health = max_health
	
