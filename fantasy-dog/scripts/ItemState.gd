class_name ItemState
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var defend_state: State
@export var enemy_state: State

@onready var sub_action_list: VBoxContainer = $"../../Options/SubActions/SubActionList"
@onready var item_display: VBoxContainer = $"../../Options/SubActions/ItemDisplay"
@onready var item_sprite: AnimatedSprite2D = $"../../Options/SubActions/ItemDisplay/Sprite2D"
@onready var item_label: Label = $"../../Options/SubActions/ItemDisplay/act1-desc"

@onready var attack: Button = $"../../Options/Actions/ActionList/attack"
@onready var defend: Button = $"../../Options/Actions/ActionList/defend"
@onready var item: Button = $"../../Options/Actions/ActionList/item"

# Item definitions with weights and effects
const ITEMS = [
	{"name": "Red Bottle", "weight": 20, "effect": "heal_hp", "value": 30, "frame": 2},
	{"name": "Blue Bottle", "weight": 20, "effect": "heal_mp", "value": 20, "frame": 0},
	{"name": "Green Bottle", "weight": 10, "effect": "poison", "value": 10, "frame": 1},
	{"name": "Ham", "weight": 15, "effect": "heal_both", "hp": 20, "mp": 15, "frame": 3},
	{"name": "Bone", "weight": 15, "effect": "skip", "value": 0, "frame": 4},
	{"name": "Flower", "weight": 10, "effect": "defense_down", "value": 0, "frame": 5},
	{"name": "Gun", "weight": 10, "effect": "damage", "value": 15, "frame": 6}
]

var character = null
var is_rolling = false
var rolled_item = null
var item_selected = false

func enter() -> void:
	character = Global.get_current_player()
	# since item has no sub actions, hide the contents of sub action list
	sub_action_list.hide()
	item_display.show()
	# show the explanation and display of item feature
	item_label.text = "Press Accept to Roll!"
	is_rolling = false
	rolled_item = null
	item_selected = false
	print("ITEM STATE")

func process_input(event: InputEvent):
	# Prevent input while rolling
	if is_rolling:
		return null

	# change state based on button focus
	if defend.has_focus() and not item_selected:
		return defend_state
	elif attack.has_focus() and not item_selected:
		return attack_state
	if Input.is_action_just_pressed("ui_accept"):
		if not item_selected:
			# Roll for item and show it to player
			_roll_and_preview_item()
			return null
		else:
			# Item has been rolled, now queue it
			Global.add_action_to_queue(character, "item", rolled_item)
			Global.declare("%s will use %s!" % [character.get_character_name(), rolled_item.name])
			print("Character queued item: ", rolled_item.name)

			# Move to next character or execution phase
			Global.end_turn()
			if !Global.player_turn_end():
				# Next character's turn
				return attack_state
			else:
				# Both characters selected, move to execution phase
				return enemy_state

func process_frame(delta: float):
	return null


func _roll_and_preview_item() -> void:
	is_rolling = true
	item_label.text = "Rolling..."

	# Start animation if it's an AnimatedSprite2D
	if item_sprite.is_playing():
		item_sprite.stop()

	# Animate rolling
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Quick spin animation
	for i in range(10):
		item_sprite.frame = rng.randi_range(0, 6)
		await get_tree().create_timer(0.1).timeout

	# Pick final item using weighted RNG
	var final_item = _weighted_random_item()
	item_sprite.frame = final_item.frame

	# Stop any animation and keep it on the selected frame
	if item_sprite.is_playing():
		item_sprite.stop()

	rolled_item = final_item
	item_label.text = "%s\nPress Accept to confirm!" % final_item.name

	is_rolling = false
	item_selected = true


func _roll_and_use_item() -> void:
	is_rolling = true
	item_label.text = "Rolling..."

	# Animate rolling
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Quick spin animation
	for i in range(10):
		item_sprite.frame = rng.randi_range(0, 6)
		await get_tree().create_timer(0.1).timeout

	# Pick final item using weighted RNG
	var final_item = _weighted_random_item()
	item_sprite.frame = final_item.frame
	item_label.text = final_item.name

	await get_tree().create_timer(0.5).timeout

	# Apply effect
	_apply_item_effect(final_item)

	# End turn
	is_rolling = false
	character.finished_action()


func _weighted_random_item() -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Calculate total weight
	var total_weight = 0
	for item in ITEMS:
		total_weight += item.weight

	# Pick random value
	var rand_value = rng.randi_range(0, total_weight - 1)

	# Find item
	var current_weight = 0
	for item in ITEMS:
		current_weight += item.weight
		if rand_value < current_weight:
			return item

	return ITEMS[0]  # Fallback


func _apply_item_effect(item_data: Dictionary) -> void:
	# Ensure character is set
	if not character:
		character = Global.get_current_player()

	match item_data.effect:
		"heal_hp":
			character.currentHP = min(character.maxHP, character.currentHP + item_data.value)
			character.updateBar.emit()
			Global.declare("%s used %s! Restored %d HP!" % [
				character.get_character_name(),
				item_data.name,
				item_data.value
			])

		"heal_mp":
			character.currentMP = min(character.maxMP, character.currentMP + item_data.value)
			character.updateBar.emit()
			Global.declare("%s used %s! Restored %d MP!" % [
				character.get_character_name(),
				item_data.name,
				item_data.value
			])

		"poison":
			character.take_damage(item_data.value)
			Global.declare("%s used %s! Took %d poison damage!" % [
				character.get_character_name(),
				item_data.name,
				item_data.value
			])

		"heal_both":
			character.currentHP = min(character.maxHP, character.currentHP + item_data.hp)
			character.currentMP = min(character.maxMP, character.currentMP + item_data.mp)
			character.updateBar.emit()
			Global.declare("%s used %s! Restored %d HP and %d MP!" % [
				character.get_character_name(),
				item_data.name,
				item_data.hp,
				item_data.mp
			])

		"skip":
			Global.declare("%s used %s! Nothing happened..." % [
				character.get_character_name(),
				item_data.name
			])

		"defense_down":
			# Pick random alive enemy
			var alive_enemies = Global.enemy_list().filter(func(e): return e and e.is_alive())
			if alive_enemies.size() > 0:
				var rng := RandomNumberGenerator.new()
				rng.randomize()
				var target = alive_enemies[rng.randi_range(0, alive_enemies.size() - 1)]
				# TODO: Implement defense debuff system (for now just visual)
				Global.declare("%s used %s on %s! Defense lowered!" % [
					character.get_character_name(),
					item_data.name,
					target.name
				])
			else:
				Global.declare("%s used %s! No targets!" % [
					character.get_character_name(),
					item_data.name
				])

		"damage":
			# Pick random alive enemy
			var alive_enemies = Global.enemy_list().filter(func(e): return e and e.is_alive())
			if alive_enemies.size() > 0:
				var rng := RandomNumberGenerator.new()
				rng.randomize()
				var target = alive_enemies[rng.randi_range(0, alive_enemies.size() - 1)]
				target.take_damage(item_data.value)
				Global.declare("%s used %s! %s takes %d damage!" % [
					character.get_character_name(),
					item_data.name,
					target.name,
					item_data.value
				])
			else:
				Global.declare("%s used %s! No targets!" % [
					character.get_character_name(),
					item_data.name
				])
