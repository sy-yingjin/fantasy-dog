extends Node
# this is the state machine that will handle 
# states and transitions of the UI menu / action selection

@export var starting_state: State
var current_state: State
var states: Dictionary = {}

# initializing the state machine by giving each child state 
# a reference to parent object it belongs to and enter 
# default starting_state

func init(parent: Control) -> void:
	for child in get_children():
		child.parent = parent
		
	# initializing to the default state
	change_state(starting_state)
	
# change to new state by exiting the previous state
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

# pass through functioins for the control UI to call
# handling state changes as needed

#func process_physics(delta: float) -> void:
	#var new_state = current_state.process_input(delta)
	## new state will be called based on the input event
	
		
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float) -> void:
	var new_state = current_state.process_input(delta)
	if new_state:
		change_state(new_state)
