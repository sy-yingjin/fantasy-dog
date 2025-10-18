class_name AttackState
extends State
# connect to state machine

 # character's turn, attack is selected
 # display list of attacks and description

# list of possible states to go from this state
@export var defend_state: State
@export var sub_attack1_state: State
@export var sub_attack2_state: State
@export var item_state: State

@onready var sub_action_list: VBoxContainer = $"../../SubActions/SubActionList"
@onready var item_display: VBoxContainer = $"../../SubActions/ItemDisplay"

@onready var attack: Button = $"../../Actions/ActionList/attack"
@onready var defend: Button = $"../../Actions/ActionList/defend"
@onready var item: Button = $"../../Actions/ActionList/item"
@onready var action_1: Button = $"../../SubActions/SubActionList/action1"
@onready var action_2: Button = $"../../SubActions/SubActionList/action2"

var character = null

func enter() -> void:
	character = Global.get_current_player()
	# print(character.get_character_name())
	attack.grab_focus()
	item_display.hide()
	sub_action_list.show()
	print("START ATTACK")
	print("HELLO")
	var i = 0
	for child in sub_action_list.get_children():
		# change the text in the sub action list accordingly
		if child is Button:
			# print(child)
			# attack button
			child.text = character.get_Act(i)
			i += 1
		else: 
			# description of attack
			child.text = character.get_ActDesc(i-1)
			# print(child)	

func process_input(event: InputEvent):
	# change state based on ui input
	if defend.has_focus():
		return defend_state
	elif item.has_focus(): 
		return item_state
	elif action_2.has_focus():
		return sub_attack2_state
	if Input.is_action_just_pressed("ui_accept") or action_1.has_focus():
		print("ACCEPT PRESSED")
		# move to sub attack 1 option
		return sub_attack1_state
	 
	return null
	
