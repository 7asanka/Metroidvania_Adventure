extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 3
var max_health = 3
var can_double_jump = false
var has_double_jumped = false
var attack_value = 1
var direction: int
var MAttackCooldown = 5

signal health_changed(new_health)
signal respawn_requested

@onready var anim = $AnimationPlayer
@onready var fsm = $FSM
@onready var MAttack_anim = $MAttackHitbox/AnimationPlayer
@onready var swordHitbox = $MAttackHitbox/CollisionShape2D
@onready var MAttackSprite = $MAttackHitbox/CollisionShape2D/AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fsm.change_state("Idle")
	add_to_group("player")
	load_player_data()

func _process(delta):
	fsm.update(delta)
	
	if Input.is_action_just_pressed("melle_attack"):
		fsm.change_state("MAttack")
	if Input.is_action_just_pressed("move_left"):
		direction = -1
	elif Input.is_action_just_pressed("move_right"):
		direction = 1
		
	if direction > 0:
		MAttackSprite.flip_h = false
	elif direction < 0:
		MAttackSprite.flip_h = true
		
	if health <= 0:
		respawn_requested.emit()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("move_left", "move_right")
		
	fsm.physics_update(delta)
	move_and_slide()

func take_damage(value):
	health -= value
	health_changed.emit(health)
	has_double_jumped = false  # Reset double jump when hit
	fsm.change_state("Hurt")

func respawn():
	get_tree().reload_current_scene()

func save_checkpoint(position):
	SaveManager.player_data["last_checkpoint"] = position
	SaveManager.player_data["max_health"] = max_health
	SaveManager.player_data["can_double_jump"] = can_double_jump
	SaveManager.save_game()

func load_player_data():
	SaveManager.load_game()
	var data = SaveManager.player_data
	max_health = data.get("max_health", 3)
	health = data.get("current_health", max_health)
	can_double_jump = data.get("can_double_jump", false)
	global_position = data.get("last_checkpoint", Vector2.ZERO)
