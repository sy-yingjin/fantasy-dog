extends TextureRect

const OFFSET: Vector2 = Vector2(-50,-170)

var target: Node = null
	
func _process(_delta: float) -> void:
	target = Global.get_current_player()
	global_position = target.global_position + OFFSET
	
	if Global.player_turn_end():
		self.hide()
	else: 
		self.show()
	
