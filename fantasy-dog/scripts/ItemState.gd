class_name ItemState
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var defend_state: State
@export var enemy_state: State

@onready var sub_action_list: VBoxContainer = $"../../SubActions/SubActionList"
@onready var item_display: VBoxContainer = $"../../SubActions/ItemDisplay"

@onready var attack: Button = $"../../Actions/ActionList/attack"
@onready var defend: Button = $"../../Actions/ActionList/defend"
@onready var item: Button = $"../../Actions/ActionList/item"


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
		if character.get_character_name() == "Hirow":
			# if current player is knight, go to next player
			Global.next_player()
			print("MAGE'S TURN")
			return attack_state
		else: 
			get_viewport().gui_release_focus()
			# current player is the mage, meaning the player's turn must end
			print("ENEMY TURN")
			return enemy_state
