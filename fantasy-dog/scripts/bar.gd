extends TextureProgressBar

@export var player: Player
@export var type: String

func _ready() -> void:
	if type == "HP":
		max_value = player.maxHP
		value = max_value 
	elif type == "MP":
		max_value = player.maxMP
		value = max_value 
		
	player.updateBar.connect(update)
	update()
	
func update():
	if type == "HP":
		value = clamp(player.currentHP, 0.0, player.maxHP)
		print("%s HP: %d" % [player.get_character_name(), int(value)])
	elif type == "MP":
		value = clamp(player.currentMP, 0.0, player.maxMP)
		print("%s MP: %d" % [player.get_character_name(), int(value)])
		
