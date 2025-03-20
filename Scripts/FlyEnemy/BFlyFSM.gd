extends Node

var states = {}
var current_state_node
var current_state
var previous_state

func _ready():
	var object = get_parent()
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.object = object
			child.fsm = self

func update(delta):
	if not current_state_node: return
	current_state_node.update(delta)
	
func physics_update(delta):
	if not current_state_node: return
	current_state_node.physics_update(delta)
	
func change_state(next_state):
	if current_state_node:
		current_state_node.exit()
	previous_state = current_state
	current_state = next_state
	current_state_node = states[current_state.to_lower()]
	current_state_node.enter()
