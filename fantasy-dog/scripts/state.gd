class_name State
extends Node

# hold a reference to the parent so that it can be controlled by the state
var parent: Control

func enter() -> void:
	#var character = get_node("Knight")
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	return null
