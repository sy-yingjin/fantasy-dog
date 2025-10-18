class_name SubAttack2State
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var defend_state: State
@export var item_state: State
@export var enemy_state: State
@export var sub_attack1_state: State

@onready var item_display: VBoxContainer = $"../../SubActions/ItemDisplay"

@onready var action_1: Button = $"../../SubActions/SubActionList/action1"
@onready var action_2: Button = $"../../SubActions/SubActionList/action2"
@onready var item: Button = $"../../Actions/ActionList/item"
@onready var defend: Button = $"../../Actions/ActionList/defend"
@onready var attack: Button = $"../../Actions/ActionList/attack"

var character = null

func enter() -> void:
	character = Global.get_current_player()
	item_display.hide()

func process_input(event: InputEvent):
	# change state based on ui input
	if action_1.has_focus():
		# move to sub attack 1 option
		return sub_attack1_state
	elif item.has_focus():
		return item_state
	elif defend.has_focus():
		return defend_state
	elif attack.has_focus():
		return attack_state
	if Input.is_action_just_pressed("ui_accept"):
		# execute sub attack 2 and check turn
		character.attack(2)
		if character.get_character_name() == "Hirow":
			# if current player is knight, go to next player
			Global.next_player()
			return attack_state
		else: 
			get_viewport().gui_release_focus()
			print("ENEMY'S TURN")
			# current player is the mage, meaning the player's turn must end
			return enemy_state
