extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim = $AnimationPlayer
@onready var fsm = $FSM
@onready var MAttack_anim = $MAttackHitbox/AnimationPlayer
@onready var swordHitbox = $MAttackHitbox/CollisionShape2D #Swords hitbox
@onready var MAttackSprite = $MAttackHitbox/CollisionShape2D/AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fsm.change_state("Idle")
	add_to_group("player")

func _process(delta):
	fsm.update(delta)
	if Input.is_action_just_pressed("melle_attack"):
		fsm.change_state("MAttack")
	
func _physics_process(delta):
	# Add the gravity.
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
