class_name ItemState
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var defend_state: State
@export var enemy_state: State

@onready var sub_action_list: VBoxContainer = $"../../Options/SubActions/SubActionList"
@onready var item_display: VBoxContainer = $"../../Options/SubActions/ItemDisplay"

@onready var attack: Button = $"../../Options/Actions/ActionList/attack"
@onready var defend: Button = $"../../Options/Actions/ActionList/defend"
@onready var item: Button = $"../../Options/Actions/ActionList/item"


var character = null

func enter() -> void:
	character = Global.get_current_player()
	# since item has no sub actions, hide the contents of sub action list
	sub_action_list.hide()
	item_display.show()
	# show the explanatioin and display of item feature
	print("ITEM STATE")
	
func process_input(event: InputEvent):
	# change state based on button focus
	if defend.has_focus():
		return defend_state
	elif attack.has_focus():
		return attack_state
	if Input.is_action_just_pressed("ui_accept"):
		# use item
		character.use_item()
		print("Character uses an item")
		character.finished_action()
		# action executed, wait for timer to end before proceed to next turn

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
