extends Area2D

var can_check = false
var player = null

@export var checkpoint_id: String  # Unique identifier for this checkpoint
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var e_key_sprite = $EKeySprite
@onready var label = $Label

signal checkpoint_reached(id, position)

func _ready():
	connect("body_entered", _on_body_entered)
	anim.play("default")

func _process(delta):
	if Input.is_action_just_pressed("interact") and can_check:
		use_checkpoint()

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure only the player triggers it
		e_key_sprite.visible = true
		can_check = true
		player = body

func use_checkpoint():
	if player:  # Ensure player is detected
		checkpoint_reached.emit(checkpoint_id, global_position)
		player.save_checkpoint(checkpoint_id, global_position)  # Save directly to player
		anim.play("newSave")
		label.visible = true
		player.health = player.max_health
		player.health_changed.emit(player.max_health)
		print("Checkpoint used, position saved:", global_position)
		await anim.animation_finished
		anim.play("default")
		await get_tree().create_timer(1).timeout
		label.visible = false


func _on_body_exited(body):
	if body.is_in_group("player"):
		e_key_sprite.visible = false
		can_check = false
