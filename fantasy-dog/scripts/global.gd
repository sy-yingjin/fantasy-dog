extends Node
# global access

var knight
var mage
var enemyA
var enemyB
var boss
var current_player: Player = null
var target_enemy = null
var turn_ended = false
var existing_enemies = []
var player_attack = null
var enemy_select = false
var queued_action
var declare_label: Label
var battle_over: bool = false
var restarting: bool = false

# Action queue system for both characters
var action_queue: Array = []  # Array of dictionaries: {character: Player, action_type: String, target: Enemy}
var current_action_index: int = 0
var executing_actions: bool = false
var in_execution_phase: bool = false  # Flag to prevent animation resets during execution

# I made this global script to share variables among states and characters easier

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait for scene tree to be ready
	await get_tree().process_frame

	# Try initial binding of scene nodes when the game first starts
	rebind_scene_nodes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_knight() -> Player:
	return knight
	
func get_mage() -> Player:
	return mage	
	
func get_current_player() -> Node:
	return current_player
	
func player_turn_end() -> bool:
	return turn_ended
	
func start_turn() -> void:
	current_player = knight
	action_queue.clear()
	current_action_index = 0
	executing_actions = false
	in_execution_phase = false

func end_turn() -> void:
	print("FROM GLOBAL, CURRENT PLAYER ", current_player)
	if current_player == knight:
		current_player = mage
	elif current_player == mage:
		# Both characters have selected their actions
		# Don't switch back to knight, instead mark that selection phase is done
		print("BOTH CHARACTERS SELECTED ACTIONS")
		turn_ended = true
	
func get_current_actor() -> Node:
	# return which node is currently doiong action
	# currently returning a placeholder node but the actual one
	# should also include enemy nodes
	return get_current_player()
	
func enemy_list() -> Array:
	return existing_enemies

func remove_enemy(enemy_node: Node) -> void:
	# Keep index alignment with enemy buttons: null out the slot
	var idx := existing_enemies.find(enemy_node)
	if idx != -1:
		existing_enemies[idx] = null
	# After removing, check victory condition
	check_battle_end()
	
func queue_action(type: int) -> void:
	queued_action = type

func get_queued_action() -> String:
	if queued_action == 1:
		return "sub_atk_1"
	else:
		return "sub_atk_2"

# Add an action to the queue
func add_action_to_queue(character: Player, action_type: String, target = null) -> void:
	action_queue.append({
		"character": character,
		"action_type": action_type,
		"target": target
	})
	print("Action queued for %s: %s" % [character.get_character_name(), action_type])

# Check if both characters have queued their actions
func all_actions_queued() -> bool:
	var knight_queued = false
	var mage_queued = false
	for action in action_queue:
		if action["character"] == knight:
			knight_queued = true
		if action["character"] == mage:
			mage_queued = true
	return knight_queued and mage_queued

# Execute all queued actions
func execute_queued_actions() -> void:
	executing_actions = true
	current_action_index = 0

func declare(text: String) -> void:
	if declare_label:
		declare_label.text = text
		print("[EVENT] ", text)  # Also log to console

# Rebind references to nodes in the current Battle scene.
# Safe to call multiple times; returns true if binding succeeded.
func rebind_scene_nodes() -> bool:
	var battle := get_node_or_null("/root/Battle")
	if battle == null:
		return false

	# Bind player nodes
	knight = get_node_or_null("/root/Battle/Knight")
	mage = get_node_or_null("/root/Battle/Mage")
	# Bind enemies
	enemyA = get_node_or_null("/root/Battle/Options/Enemies/Enemy A Button/Enemy A")
	enemyB = get_node_or_null("/root/Battle/Options/Enemies/Enemy B Button/Enemy B")
	boss = get_node_or_null("/root/Battle/Options/Enemies/Boss Button/catBoss")
	# Enemies list
	existing_enemies = [enemyA, enemyB, boss]

	# Set current player if missing
	if knight != null:
		current_player = knight

	# Reset runtime flags after binding
	turn_ended = false
	enemy_select = false
	queued_action = null
	battle_over = false
	restarting = false
	action_queue.clear()
	current_action_index = 0
	executing_actions = false
	in_execution_phase = false

	# Bind declare label
	declare_label = get_node_or_null("/root/Battle/Action Declare")
	if declare_label:
		declare_label.text = "Players' Turn"
	else:
		push_error("Could not find Action Declare label!")

	return is_instance_valid(current_player)

# Returns true if at least one enemy is still alive/present
func _any_enemies_alive() -> bool:
	for e in existing_enemies:
		if e and e.is_alive():
			return true
	return false

# Returns true if at least one party member is alive
func _any_players_alive() -> bool:
	return (knight and knight.currentHP > 0.0) or (mage and mage.currentHP > 0.0)

func check_battle_end() -> void:
	if battle_over:
		return
	var enemies_alive := _any_enemies_alive()
	var players_alive := _any_players_alive()
	if not enemies_alive:
		show_end_panel(true)
		return
	if not players_alive:
		show_end_panel(false)
		return

func show_end_panel(did_win: bool) -> void:
	battle_over = true
	# Hide options UI to prevent further input
	var options := get_node_or_null("/root/Battle/Options")
	if options:
		options.visible = false
		# Release any focused control
		if options is Control:
			get_viewport().gui_release_focus()
	# Update declare label
	declare("Victory!" if did_win else "Defeat...")
	# Show the overlay panel if present
	var end_panel := get_node_or_null("/root/Battle/EndPanel")
	if end_panel and end_panel.has_method("show_result"):
		end_panel.show_result(did_win)
	else:
		# Fallback: print to console
		print("Battle ended - ", ("WIN" if did_win else "LOSS"))

func restart_battle() -> void:
	# Re-initialize by reloading the current scene
	restarting = true
	battle_over = false
	# Clear references to avoid touching freed instances during reload
	current_player = null
	knight = null
	mage = null
	enemyA = null
	enemyB = null
	boss = null
	existing_enemies = []
	target_enemy = null
	queued_action = null
	# Reload the scene
	get_tree().reload_current_scene()
