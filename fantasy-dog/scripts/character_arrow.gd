extends TextureRect

const OFFSET: Vector2 = Vector2(160,-20)

var target: Node = null
	
func _process(_delta: float) -> void:
	# Update target from Global, but guard against invalid references during reloads
	target = Global.get_current_player() if Global != null else null
	if Global == null or target == null or not is_instance_valid(target):
		self.hide()
		return
	# Position arrow at target
	global_position = target.global_position + OFFSET
	# Show only during player turn
	if Global.player_turn_end():
		self.hide()
	else:
		self.show()
	
