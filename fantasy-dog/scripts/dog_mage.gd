extends Player

# link HP and MP bar from UI

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sprite = $atk_effect
@onready var timer: Timer = $Timer

func _ready() -> void:
	# fill up the needed information of the dog knight
	maxHP = 100
	maxMP = 100
	currentHP = 100 # start at 1 HP for testing/low health
	currentMP = 100 # bar testing
	player_name = "Mayge"
	atk_1 = "Maggik"
	atk_1_desc = "Awooo Spell"
	atk_2 = "Aura Farming"
	atk_2_desc = "So much aura it hurts"
	atk_list = [atk_1, atk_2]
	atk_descriptions = [atk_1_desc, atk_2_desc]
	
	print(atk_list)

	# add other features
func attack(type: String) -> void:
	var dmg := 0.0

	if type == "sub_atk_1":
		## do type 1 attack
		print("DOING BASIC ATTACK - love, Mage")
		executed_action = "Maggik"
		dmg = 12.0
		attack_sprite.play("normal")
		used_MP(4)  # Costs 4 MP
	else:
		## do type 2 attack
		# updateBar.emit() to update MP bar in UI
		print("DOING STRONG ATTACK - love, Mage")
		executed_action = "Aura Farming"
		dmg = 28.0
		attack_sprite.play("strong")
		used_MP(15)  # Costs 15 MP

	animated_sprite.play("attack")

	# Apply damage to target
	if Global.target_enemy and Global.target_enemy.is_alive():
		Global.target_enemy.take_damage(dmg)
		var actual := int(Global.target_enemy.get_last_damage_taken()) if Global.target_enemy.has_method("get_last_damage_taken") else int(dmg)
		Global.declare("%s uses %s! %s takes %d HP!" % [
			player_name,
			executed_action,
			Global.target_enemy.name,
			actual
		])
	else:
		Global.declare("%s uses %s!" % [player_name, executed_action])

func defend() -> void:
	super()
	animated_sprite.play("defend")

func default() -> void:
	# Don't interrupt damage animation
	if animated_sprite.animation != "damage":
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
	# Don't reset to default during execution phase
	if executed_action != "defend" and not Global.in_execution_phase:
		if Global.player_turn_end():
			self.default()

func _on_timer_timeout() -> void:
	timer.stop()
	action_done = true

func _on_animated_sprite_2d_animation_finished() -> void:
	# Return to default animation after damage or other animations finish
	if animated_sprite.animation == "damage":
		print("Mage damage animation finished, returning to default")
		animated_sprite.play("default")

func take_damage(damage: float) -> void:
	# do the damage logic from parent
	print("Mage taking damage, playing damage animation")
	animated_sprite.play("damage")
	super(damage)
	
	
	
func used_MP(amount: float):
	super(amount)


# Hide the player when defeated, then delegate to base to declare and end-check
func die() -> void:
	if is_instance_valid(animated_sprite):
		animated_sprite.hide()
	if is_instance_valid(attack_sprite):
		attack_sprite.hide()
	super.die()
