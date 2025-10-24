extends Player

# link HP and MP bar from UI

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sprite = $atk_effect
@onready var timer: Timer = $Timer

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
	super()
	animated_sprite.play("defend")

func default() -> void:
	animated_sprite.play("default")
	attack_sprite.play("default")

func finished_action() -> void:
	timer.start()
	print("TIMER START")
	# wait for a few moments until the next turn
	
func is_done() -> bool:
	return action_done

func _process(type: float) -> void:
	# if attack_sprite.is_playing():
	if executed_action != "defend":
		if Global.player_turn_end():
			self.default()

func _on_timer_timeout() -> void:
	timer.stop()
	action_done = true
