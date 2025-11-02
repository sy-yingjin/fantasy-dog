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

	# Announce enemy turn
	Global.declare("Enemies' Turn")

	# Wait a frame to ensure UI is hidden
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout  # Pause before enemies act

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
	
	# Return to player turn
	Global.turn_ended = false
	Global.declare("Players' Turn")
	

	# Show UI elements before transitioning
	actions.show()
	sub_actions.show()
	menu_cursor.show()

	# Transition back to player turn
	state_machine.change_state(attack_state)
