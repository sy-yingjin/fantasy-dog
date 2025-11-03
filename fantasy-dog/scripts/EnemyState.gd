class_name EnemyState
extends State

@export var attack_state: State

@onready var actions: Control = $"../../Options/Actions"
@onready var sub_actions: Control = $"../../Options/SubActions"
@onready var enemy_arrow: TextureRect = $"../../Enemy Arrow"
@onready var menu_cursor: TextureRect = $"../../MenuCursor"
@onready var state_machine: Node = $".."



func enter() -> void:
	# Hide all UI elements
	actions.hide()
	sub_actions.hide()
	enemy_arrow.hide()
	menu_cursor.hide()

	# First, execute all queued player actions
	Global.in_execution_phase = true  # Prevent animation resets during execution
	Global.declare("Executing Actions...")
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout

	# Execute each queued action
	for action_data in Global.action_queue:
		var character = action_data["character"]
		var action_type = action_data["action_type"]
		var target = action_data["target"]

		if not character or not character.is_alive():
			continue

		if action_type == "defend":
			# Execute defend action
			character.defend()
			Global.declare("%s defends!" % character.get_character_name())
			await get_tree().create_timer(0.5).timeout  # Give time for defend animation
			character.finished_action()
		elif action_type == "item":
			# Execute item action with the pre-rolled item
			var item_data = target  # The item was stored in the target field
			await _execute_item_action(character, item_data)
			continue  # Skip the wait logic since item has its own timing
		else:
			# Execute attack action
			if target and target.is_alive():
				Global.target_enemy = target
				character.attack(action_type)
				# Wait for attack animation to play
				await get_tree().create_timer(1.5).timeout
				character.finished_action()
			else:
				# Target is dead, skip this action
				Global.declare("%s's target is defeated!" % character.get_character_name())
				continue

		# Wait for action to complete
		while not character.is_done():
			await get_tree().process_frame

		await get_tree().create_timer(0.5).timeout

	# Clear the action queue after execution
	Global.action_queue.clear()

	# Check for battle end after player actions
	if Global.has_method("check_battle_end"):
		Global.check_battle_end()
		if Global.battle_over:
			return

	# After players finish their actions, clear any enemy defend statuses
	for e in Global.enemy_list():
		if e and e.has_method("clear_defend"):
			e.clear_defend()

	# Now enemies act
	Global.declare("Enemies' Turn")
	await get_tree().create_timer(1.0).timeout

	# Small enemies act
	for e in Global.enemy_list():
		if e and e != Global.boss and e.is_alive():
			e.decide_action()
			await get_tree().create_timer(1.5).timeout  # Wait for animation

	# Boss acts
	if Global.boss and Global.boss.is_alive():
		Global.boss.choose_attack()
		await get_tree().create_timer(1.5).timeout  # Wait for attack animation

	# Check for battle end conditions
	if Global.has_method("check_battle_end"):
		Global.check_battle_end()
		if Global.battle_over:
			return

	# Clear defend status for players after boss finishes its turn
	if Global.knight and Global.knight.has_method("clear_defend"):
		Global.knight.clear_defend()
	if Global.mage and Global.mage.has_method("clear_defend"):
		Global.mage.clear_defend()


	await get_tree().create_timer(2).timeout

	# Return to player turn - reset to first actor and flags
	Global.start_turn()
	Global.in_execution_phase = false  # Re-enable animation resets
	Global.declare("Players' Turn")


	# Show UI elements before transitioning
	actions.show()
	sub_actions.show()
	menu_cursor.show()

	# Transition back to player turn
	state_machine.change_state(attack_state)


# Helper function to execute item actions (from ItemState)
func _execute_item_action(character: Player, item_data) -> void:
	# Use the pre-rolled item data from the queue
	var final_item = item_data
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Apply effect
	match final_item.effect:
		"heal_hp":
			character.currentHP = min(character.maxHP, character.currentHP + final_item.value)
			character.updateBar.emit()
			Global.declare("%s used %s! Restored %d HP!" % [
				character.get_character_name(),
				final_item.name,
				final_item.value
			])

		"heal_mp":
			character.currentMP = min(character.maxMP, character.currentMP + final_item.value)
			character.updateBar.emit()
			Global.declare("%s used %s! Restored %d MP!" % [
				character.get_character_name(),
				final_item.name,
				final_item.value
			])

		"poison":
			character.take_damage(final_item.value)
			Global.declare("%s used %s! Took %d poison damage!" % [
				character.get_character_name(),
				final_item.name,
				final_item.value
			])

		"heal_both":
			character.currentHP = min(character.maxHP, character.currentHP + final_item.hp)
			character.currentMP = min(character.maxMP, character.currentMP + final_item.mp)
			character.updateBar.emit()
			Global.declare("%s used %s! Restored %d HP and %d MP!" % [
				character.get_character_name(),
				final_item.name,
				final_item.hp,
				final_item.mp
			])

		"skip":
			Global.declare("%s used %s! Nothing happened..." % [
				character.get_character_name(),
				final_item.name
			])

		"defense_down":
			# Pick random alive enemy
			var alive_enemies = Global.enemy_list().filter(func(e): return e and e.is_alive())
			if alive_enemies.size() > 0:
				var target = alive_enemies[rng.randi_range(0, alive_enemies.size() - 1)]
				Global.declare("%s used %s on %s! Defense lowered!" % [
					character.get_character_name(),
					final_item.name,
					target.name
				])
			else:
				Global.declare("%s used %s! No targets!" % [
					character.get_character_name(),
					final_item.name
				])

		"damage":
			# Pick random alive enemy
			var alive_enemies = Global.enemy_list().filter(func(e): return e and e.is_alive())
			if alive_enemies.size() > 0:
				var target = alive_enemies[rng.randi_range(0, alive_enemies.size() - 1)]
				target.take_damage(final_item.value)
				Global.declare("%s used %s! %s takes %d damage!" % [
					character.get_character_name(),
					final_item.name,
					target.name,
					final_item.value
				])
			else:
				Global.declare("%s used %s! No targets!" % [
					character.get_character_name(),
					final_item.name
				])

	character.finished_action()
	while not character.is_done():
		await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
