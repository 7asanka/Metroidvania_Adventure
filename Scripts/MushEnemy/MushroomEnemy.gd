extends CharacterBody2D

var health = 3
var max_health = 3

@export var enemy_id: String  

@onready var mush_anim = $AnimationPlayer
@onready var fsm = $MushFSM

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Restore enemy position if needed
	if SaveManager.enemies.has(enemy_id):
		global_position = SaveManager.enemies[enemy_id]
	else:
		SaveManager.enemies[enemy_id] = global_position

	fsm.change_state("MushPatrol")

func _process(delta):
	fsm.update(delta)
	if health <= 0:
		await mush_anim.animation_finished
		mush_anim.play("Death")
		queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y = gravity * delta
	fsm.physics_update(delta)
	move_and_slide()

func take_damage(damage):
	health -= damage
	fsm.change_state("MushHurt")

func reset():
	fsm.change_state("MushPatrol")
	health = max_health
