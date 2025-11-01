extends Control

@onready var label: Label = $CenterContainer/VBoxContainer/Label
@onready var restart_button: Button = $CenterContainer/VBoxContainer/RestartButton

func _ready() -> void:
	visible = false
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)

func show_result(win: bool) -> void:
	if label:
		label.text = ("Victory!" if win else "Defeat...")
	visible = true
	# Ensure this panel captures input and blocks underlying UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	restart_button.grab_focus()

func _on_restart_pressed() -> void:
	if Global and "restart_battle" in Global:
		Global.restart_battle()
