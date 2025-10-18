class_name DefendState
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var item_state: State
@export var enemy_state: State

@onready var sub_action_list: VBoxContainer = $"../../SubActions/SubActionList"
@onready var item_display: VBoxContainer = $"../../SubActions/ItemDisplay"

@onready var item: Button = $"../../Actions/ActionList/item"
@onready var attack: Button = $"../../Actions/ActionList/attack"


var character = null

func enter() -> void:
	character = Global.get_current_player()
	# since defend has no sub actions, hide the contents of sub action list
	sub_action_list.hide()
	item_display.hide()
	print("START DEFEND")
	
func process_input(event: InputEvent):
	# change state based on button focus
	if item.has_focus():
		return item_state
	elif attack.has_focus():
		return attack_state
	elif Input.is_action_just_pressed("ui_accept"):
		character.defend()
		print("Character uses defend!")
		# action executed, check if turn ended to start enemy action
		if character.get_character_name() == "Hirow":
			# if current player is knight, go to next player
			Global.next_player()
			print("MAGE'S TURN")
			return attack_state
		if Global.player_turn_end():
			get_viewport().gui_release_focus()
			print("ENEMY'S TURN")
			return enemy_state
		
