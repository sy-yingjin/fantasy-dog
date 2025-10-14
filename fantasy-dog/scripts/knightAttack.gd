class_name KnightAttackState
extends State
# connect to state machine

# knight's turn, attack is selected
# display list of attacks and description

@onready var v_box_container: VBoxContainer = $Container/SubActions/VBoxContainer

func physics_update(delta):
	var character = Global.get_knight()
	# get knight's list of attacks
	var i = 0
	for child in v_box_container.get_children():
		if child is Button:
			# attack button
			child.text = character.get_Act(1, i)
			i += 1
		else: 
			# description of attack
			child.text = character.get_ActDesc(1, i-1)
	
func handle_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_state("")
