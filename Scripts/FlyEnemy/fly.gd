extends CharacterBody2D

var health = 2
var max_health = 2
var direction: int
var chasing = false
var taking_damage = false
@export var enemy_id: String  

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var fsm = $BFlyFSM
@onready var hurtbox = $CollisionShape2D

func _ready():
	# Restore enemy position if needed
	if SaveManager.enemies.has(enemy_id):
		global_position = SaveManager.enemies[enemy_id]
	else:
		SaveManager.enemies[enemy_id] = global_position

	fsm.change_state("BFlyPatrol")

func _process(delta):
	fsm.update(delta)

	if velocity.x > 0:
		sprite.flip_h = true
		direction = 1
	elif velocity.x < 0:
		direction = -1
		sprite.flip_h = false

func _physics_process(delta):
	fsm.physics_update(delta)
	move_and_slide()

func take_damage(damage):
	taking_damage = true
	if health <= 0:  
		print("Already dead, ignoring extra hit.")
		return

	health -= damage
	print("Fly HP:", health, "Damage taken:", damage)  # Debugging

	if health <= 0:
		print("Fly should die now.")
		fsm.change_state("BFlyDeath")
	else:
		fsm.change_state("BFlyHurt")

func reset():
	fsm.change_state("BFlyPatrol")
	health = max_health


func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
		body.velocity = (body.global_position - global_position).normalized() * Vector2(300, 800)
