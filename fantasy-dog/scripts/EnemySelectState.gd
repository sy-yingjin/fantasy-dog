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

@onready var enemies: Control = $"../Options/Enemies"

@onready var menu_cursor: TextureRect = $"../../MenuCursor"
@onready var enemy_arrow: TextureRect = $"../../Enemy Arrow"

@onready var other_buttons = [action_1, action_2, item, defend, attack]

var character = null
var current_enemies = null

func _ready() -> void:
	current_enemies = [enemy_a_button, enemy_b_button, boss_button]
	print(other_buttons)

func enter() -> void:
	character = Global.get_current_player()
	menu_cursor.hide()
	enemy_arrow.show()
	# disable other buttons 
	for b in other_buttons:
		b.focus_mode = Control.FOCUS_NONE
	# enable the focus on enemy buttons
	for b in current_enemies:
		b.focus_mode = Control.FOCUS_ALL
	current_enemies[0].grab_focus()
	print("SELECT ENEMIES")

func process_input(event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		# change buttons focusables
		for b in other_buttons:
			b.focus_mode = Control.FOCUS_ALL
		for b in current_enemies:
			b.focus_mode = Control.FOCUS_NONE
		# return to subattack state
		action_1.grab_focus()
		return sub_attack1_state
	elif Input.is_action_just_pressed("ui_accept"):
		# character does sub attack 1
		character.attack(1)
		Global.end_turn()
		if !Global.player_turn_end():
			return attack_state
		else: 
			# current player is the mage, meaning the player's turn must end
			get_viewport().gui_release_focus()
			print("ENEMY TURN")
			return enemy_state
	
