extends Control

@onready var continue_button = $ContinueButton

const SAVE_FILE = "user://savegame.bin"

func _ready():
	
	if not FileAccess.file_exists(SAVE_FILE):# Disable "Continue" if no save exists
		continue_button.disabled = true

func _on_new_game_button_pressed():
	# Start a new game (clear save and load level 1)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_continue_button_pressed():
	# Load last checkpoint
	SaveManager.load_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()



