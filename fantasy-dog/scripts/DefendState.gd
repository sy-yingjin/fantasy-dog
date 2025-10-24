class_name DefendState
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var item_state: State
@export var enemy_state: State

@onready var sub_action_list: VBoxContainer = $"../../Options/SubActions/SubActionList"
@onready var item_display: VBoxContainer = $"../../Options/SubActions/ItemDisplay"

@onready var item: Button = $"../../Options/Actions/ActionList/item"
@onready var defend: Button = $"../../Options/Actions/ActionList/defend"
@onready var attack: Button = $"../../Options/Actions/ActionList/attack"


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
		character.finished_action()
		print("Character uses defend!")
		# action executed, wait for timer to end before proceed to next turn
		defend.focus_mode = Control.FOCUS_NONE

func process_frame(delta: float):
	if character.is_done():
		Global.end_turn()
		print("TURN ENDED", Global.player_turn_end())
		if !Global.player_turn_end():
			return attack_state
		else:
			get_viewport().gui_release_focus()
			Global.turn_ended = true
			print("ENEMY'S TURN")
			return enemy_state
	return null
