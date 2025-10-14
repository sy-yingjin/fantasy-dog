class_name State
extends Node

@onready var state_machine = StateMachine

# hold a reference to the parent so that it can be controlled by the state

func enter() -> void:
	#var character = get_node("Knight")
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func physics_process(delta: float) -> State:
	return null
