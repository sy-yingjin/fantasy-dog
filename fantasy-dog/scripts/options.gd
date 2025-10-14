class_name Menu extends VBoxContainer

signal button_focused(button)
signal button_pressed(button)

var index: int = 0

func _ready() -> void:
	get_buttons()
	#for button in get_buttons():
		#button_focused.connect(_on_button_pressed.bind(button))
		#button_pressed.connect(_on_button_pressed().bind(button))

func get_buttons() -> Array:
	var buttons : Array[Button] = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
	return buttons;
	
	
func button_focus(n: int = index) -> void:
	var button: BaseButton = get_buttons()[n]
	button.grab_focus()
	
func _on_button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button)

func _on_focus_entered(button: BaseButton) -> void:
	emit_signal("button_focused", button)
