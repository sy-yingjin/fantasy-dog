extends Player

# link HP and MP bar from UI

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sprite = $atk_effect
@onready var timer: Timer = $Timer

var OFFSET = Vector2(0,0)

func _ready() -> void:
	# fill up the needed information of the dog knight
	maxHP = 100
	maxMP = 50
	currentHP = 50 # bar testing
	currentMP = 10 # bar testing
	player_name = "Hirow"
	atk_1 = "Braver"
	atk_1_desc = "Mighty Cut Awooo"
	atk_2 = "Aura Sword"
	atk_2_desc = "So much aura it charges your sword Awo"
	atk_list = [atk_1, atk_2]
	atk_descriptions = [atk_1_desc, atk_2_desc]
	animation = attack_sprite
	
	print(atk_list)
	#

	# add other features
func attack(type: String) -> void:
	if type == "sub_atk_1":
		## do type 1 attack
		print("DOING BASIC ATTACK - love, Knight")
		play_attack(1)
		executed_action = "Braver"
		#pass
	else:
		## do type 2 attack
		# updateBar.emit() to update MP bar in UI
		print("DOING STRONG ATTACK - love, Knight")
		executed_action = "Aura Sword"
		play_attack(2)
	
	animated_sprite.play("attack")

func play_attack(type: int) -> void:
	if type == 1:
		attack_sprite.play("normal")
	else:
		attack_sprite.play("strong")
		

func defend() -> void:
	super()
	animated_sprite.play("defend")

func default() -> void:
	animated_sprite.play("default")
	attack_sprite.play("default")
	action_done = false

func finished_action() -> void:
	super()
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
