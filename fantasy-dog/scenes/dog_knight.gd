extends Player

# link HP and MP bar from UI

func _ready() -> void:
	# fill up the needed information of the dog knight
	maxHP = 100
	maxMP = 20
	currentHP = 50 # bar testing 
	currentMP = 10 # bar testing
	player_name = "Hirow"
	atk_1 = "Braver"
	atk_1_desc = "Mighty Cut Awooo"
	atk_2 = "Sword Aura"
	atk_2_desc = "So much aura it charges your sword Awo"
	atk_list = [atk_1, atk_2]
	atk_descriptions = [atk_1_desc, atk_2_desc]
	
	print(atk_list)
	#

	# add other features
func attack(type: int) -> void:
	#if type == 1:
		## do type 1 attack
		#pass
	#else:
		## do type 2 attack
		# updateBar.emit() to update MP bar in UI
		#pass
	pass
