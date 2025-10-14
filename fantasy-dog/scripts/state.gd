class_name State
extends Node


# hold a reference to the parent so that it can be controlled by the state
var parent: Control

func enter(player: Player) -> void:
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func physics_process(delta: float) -> State:
	return null
