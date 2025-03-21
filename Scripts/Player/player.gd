extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 3
var max_health = 3
var attack_value = 1
var last_checkpoint = Vector2.ZERO  # Default spawn point

var can_double_jump = false
var has_double_jumped = false

signal health_changed(new_health)
signal respawn_requested

@onready var anim = $AnimationPlayer
@onready var fsm = $FSM
@onready var MAttack_anim = $MAttackHitbox/AnimationPlayer
@onready var swordHitbox = $MAttackHitbox/CollisionShape2D # Sword hitbox
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
	
	if health <= 0:
		respawn_requested.emit()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		MAttackSprite.flip_h = false
	elif direction < 0:
		MAttackSprite.flip_h = true
		
	if Input.is_action_pressed("dash"):
		anim.play("Run")

	fsm.physics_update(delta)
	move_and_slide()

func take_damage(value):
	health -= value
	health_changed.emit(health)
	has_double_jumped = false  # Reset double jump when hit
	fsm.change_state("Hurt")

func respawn():
	# ✅ Use GameManager’s last checkpoint position when respawning
	if GameManager.last_checkpoint != Vector2.ZERO:
		global_position = GameManager.last_checkpoint
		print("✅ Respawning at last checkpoint:", GameManager.last_checkpoint)
	else:
		print("⚠ No checkpoint found, respawning at default position.")

	health = max_health  # Restore full health
	health_changed.emit(health)

func save_checkpoint(id, position):
	last_checkpoint = position
	GameManager.player_data = {
		"max_health": max_health,
		"can_double_jump": can_double_jump,
		"position": position
	}
	GameManager.save_game()
	print("Checkpoint saved at:", position)

func load_player_data():
	var data = GameManager.save_data
	print("🔄 Loading player data:", data)  # Debug print

	if "position" in data and data["position"].size() == 2:
		last_checkpoint = Vector2(data["position"][0], data["position"][1])  
		global_position = last_checkpoint  # ✅ Spawn at last saved checkpoint
		print("✅ Player spawned at:", last_checkpoint)
	else:
		print("⚠ No checkpoint position found, spawning at default position.")

	# ✅ Ensure health & abilities are loaded too
	max_health = data.get("player", {}).get("max_health", 3)
	can_double_jump = data.get("player", {}).get("can_double_jump", false)
	health = max_health
	health_changed.emit(health)

	# ✅ Update last checkpoint in GameManager
	GameManager.last_checkpoint = last_checkpoint
