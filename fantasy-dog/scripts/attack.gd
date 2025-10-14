class_name AttackState

extends State
# attack state, attack button is selected
@onready var v_box_container: VBoxContainer = $Container/SubActions/VBoxContainer
var character = null

func enter() -> void:
	# show all sub attack options
	# cusor will only be able to navigate among the two
	character = get_node("knight")
	var i = 0
	for child in v_box_container.get_children():
		if child is Button:
			child.text = character.get_Act(1, i)
			i += 1
		else: 
			child.text = character.get_ActDesc(1, i-1)
	
func _process(delta: float) -> void:	
	var focused_node = get_viewport().gui_get_focus_owner()
	if focused_node:
		# Check if the focused node is a Button
		if focused_node is Button:
			print("Focused button: ", focused_node.name)
		else:
			print("Focused node: ", focused_node.name)
	else:
		print("No node has focus.")
	

func process_input(event: InputEvent) -> State: 
	return null


func _on_v_box_container_focus_entered() -> void:
	pass # Replace with function body.
