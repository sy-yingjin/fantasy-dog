extends Player

# link HP and MP bar from UI

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sprite = $atk_effect

func _ready() -> void:
	# fill up the needed information of the dog knight
	maxHP = 100
	maxMP = 86
	currentHP = 100 # bar testing 
	currentMP = 86 # bar testing
	player_name = "Mayge"
	atk_1 = "Maggik"
	atk_1_desc = "Awooo Spell"
	atk_2 = "Aura Farming"
	atk_2_desc = "So much aura it hurts"
	atk_list = [atk_1, atk_2]
	atk_descriptions = [atk_1_desc, atk_2_desc]
	
	print(atk_list)

	# add other features
	# add other features
func attack(type: int) -> void:
	if type == 1:
		## do type 1 attack
		print("DOING BASIC ATTACK - love, Mage")
		attack_sprite.play("normal")
	else:
		## do type 2 attack
		# updateBar.emit() to update MP bar in UI
		print("DOING STRONG ATTACK - love, Mage")
		attack_sprite.play("strong")
		
	animated_sprite.play("attack")

func defend() -> void:
	animated_sprite.play("defend")

func _process(type: float) -> void:
	if Global.player_turn_end():
		animated_sprite.play("default")
		attack_sprite.play("default")
