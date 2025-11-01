class_name EnemySelectState
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var defend_state: State
@export var item_state: State
@export var enemy_state: State
@export var sub_attack1_state: State
@export var sub_attack2_state: State

@onready var item_display: VBoxContainer = $"../../Options/SubActions/ItemDisplay"

@onready var action_1: Button = $"../../Options/SubActions/SubActionList/action1"
@onready var action_2: Button = $"../../Options/SubActions/SubActionList/action2"
@onready var item: Button = $"../../Options/Actions/ActionList/item"
@onready var defend: Button = $"../../Options/Actions/ActionList/defend"
@onready var attack: Button = $"../../Options/Actions/ActionList/attack"

@onready var enemy_a_button: TextureButton = $"../../Enemies/Enemy A Button"
@onready var enemy_b_button: TextureButton = $"../../Enemies/Enemy B Button"
@onready var boss_button: TextureButton = $"../../Enemies/Boss Button"

@onready var enemies: Control = $"../../Enemies"

@onready var menu_cursor: TextureRect = $"../../MenuCursor"
@onready var enemy_arrow: TextureRect = $"../../Enemy Arrow"

@onready var other_buttons = [action_1, action_2, item, defend, attack]

var character = null
var current_enemies = null

func _ready() -> void:
	current_enemies = [enemy_a_button, enemy_b_button, boss_button]
	# print(other_buttons)

func enter() -> void:
	character = Global.get_current_player()
	Global.enemy_select = true
	# diable menu cursor and hide it
	menu_cursor.process_mode = menu_cursor.PROCESS_MODE_DISABLED
	menu_cursor.hide()
	
	# disable other buttons 
	for b in other_buttons:
		b.focus_mode = Control.FOCUS_NONE
	
	# enable the focus on enemy buttons
	var grabbed := false
	for b in current_enemies:
		# Skip disabled/hidden buttons (defeated enemies)
		if b.visible and not b.disabled:
			b.focus_mode = Control.FOCUS_ALL
			if not grabbed:
				b.grab_focus()
				grabbed = true
		else:
			b.focus_mode = Control.FOCUS_NONE
		print("focus on ", b)
	if not grabbed:
		# Fallback: release focus if nothing is selectable
		get_viewport().gui_release_focus()
	print("SELECT ENEMIES")
	
	enemy_arrow.process_mode = enemy_arrow.PROCESS_MODE_ALWAYS

func process_input(event: InputEvent):
	if Input.is_action_just_pressed("ui_down") ||  Input.is_action_just_pressed("ui_up") ||  Input.is_action_just_pressed("ui_right"):
		#current_enemies[1].grab_focus()
		print("UI MOVE")
		print(get_viewport().gui_get_focus_owner())
		
	if Input.is_action_just_pressed("ui_cancel"):
		# change buttons focusables
		for b in other_buttons:
			b.focus_mode = Control.FOCUS_ALL
		for b in current_enemies:
			b.focus_mode = Control.FOCUS_NONE
		# return to subattack state
		action_1.grab_focus()
		
		# allows menu cursor to function again and deselect enemy
		menu_cursor.process_mode = menu_cursor.PROCESS_MODE_ALWAYS
		Global.enemy_select = false
		return sub_attack1_state
	elif Input.is_action_just_pressed("ui_accept"):
		# Get focused enemy button and set target enemy
		var focused := get_viewport().gui_get_focus_owner()
		var idx: int = current_enemies.find(focused)

		if idx >= 0:
			var target = Global.enemy_list()[idx]
			if target and target.is_alive():
				# Set the target enemy from the enemy list
				Global.target_enemy = target
				# character does the queued action on selected enemy
				character.attack(Global.get_queued_action())
				character.finished_action()
			else:
				# Ignore input if target is invalid/dead
				return null

		# allows menu cursor to function again and deselect enemy
		Global.enemy_select = false

			
func process_frame(delta: float):
	if character.is_done():
		Global.end_turn()
		print("TURN ENDED", Global.player_turn_end())
		menu_cursor.process_mode = menu_cursor.PROCESS_MODE_ALWAYS
		# If battle already ended during the action, stop here
		if Global.battle_over:
			return null
		if !Global.player_turn_end():
			return attack_state
		else:
			get_viewport().gui_release_focus()
			Global.turn_ended = true
			print("ENEMY'S TURN")
			return enemy_state
	return null
	
	
