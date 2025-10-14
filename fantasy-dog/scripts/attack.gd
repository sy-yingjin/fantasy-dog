extends State
# attack state, attack button is selected
@onready var v_box_container: VBoxContainer = $Container/SubActions/VBoxContainer

func enter(player: Player) -> void:
	# show all sub attack options
	# cusor will only be able to navigate among the two
	var i = 0
	for child in v_box_container.get_children():
		if child is Button:
			child.text = player.get_Act(1, i)
			i += 1
		else: 
			child.text = player.get_ActDesc(1, i-1)
	

func process_input(event: InputEvent) -> State: 
	return null
