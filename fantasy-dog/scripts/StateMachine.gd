extends Node
# this is the state machine that will handle 
# states and transitions of the UI menu / action selection

@export var starting_state: State
@export var enemy_select_state: State
var current_state: State


## initializing the state machine by giving each child state 
## a reference to parent object it belongs to and enter 
## default starting_state
## parent is the control node that controls the UI menu
	
func init(parent: Control) -> void:
	for child in get_children():
		child.parent = parent
	change_state(starting_state)
	print("STARTING STATE MACHINE")
	
# change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	# exit current state 
	if current_state:
		current_state.exit()
	# change new state
	current_state = new_state
	current_state.enter()
	
## pass through functions ; handling state changes as needed.
func process_physics(delta: float) -> void:
	if current_state == null:
		return
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
		
func process_input(event: InputEvent) -> void:
	if current_state == null:
		return
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float) -> void:
	if current_state == null:
		return
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func enemy_select() -> bool:
	if current_state == enemy_select_state:
		return true
	else:
		return false
