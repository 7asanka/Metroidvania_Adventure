extends Control

@onready var continue_button = $ContinueButton

const SAVE_FILE = "user://savegame.bin"
@onready var confirmation_window = $ConfirmationWindow

func _ready():
	confirmation_window.visible = false
	if not FileAccess.file_exists(SAVE_FILE):# Disable "Continue" if no save exists
		continue_button.disabled = true

func _on_new_game_button_pressed():
	# Start a new game (clear save and load level 1)
	if FileAccess.file_exists(SAVE_FILE):
		confirmation_window.visible = true
		print("box should be visible")
	else:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_continue_button_pressed():
	# Load last checkpoint
	SaveManager.load_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_no_pressed():
	confirmation_window.visible = false


func _on_yes_pressed():
	if FileAccess.file_exists(SAVE_FILE):
		SaveManager.reset_save()
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
