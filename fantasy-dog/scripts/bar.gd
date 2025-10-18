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
		value = (player.currentHP / player.maxHP) * player.maxHP
	elif type == "MP":
		value = (player.currentMP / player.maxMP) * player.maxMP
		
	print(player.get_character_name(), " HAS ", value, " ", type)
		
