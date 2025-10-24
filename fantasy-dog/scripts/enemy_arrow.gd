extends Control

const OFFSET: Vector2 = Vector2(-10,-3)

var target: Node = null

func _ready() -> void: 
	self.hide()
	get_viewport().gui_focus_changed.connect(_on_viewport_gui_focus_changed)
	set_process(false)
	
func _process(_delta: float) -> void:
	if true:
		self.hide()
	global_position = target.global_position + OFFSET
	
func _on_viewport_gui_focus_changed(node: Control) -> void:
	if node is BaseButton:
		target = node
		show()
		set_process(true)
	else:
		hide()
		set_process(false)
