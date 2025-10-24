class_name SubAttack1State
extends State

# list of possible states to go from this state
@export var attack_state: State
@export var defend_state: State
@export var item_state: State
@export var enemy_select_state: State
@export var sub_attack2_state: State

@onready var item_display: VBoxContainer = $"../../Options/SubActions/ItemDisplay"

@onready var action_1: Button = $"../../Options/SubActions/SubActionList/action1"
@onready var action_2: Button = $"../../Options/SubActions/SubActionList/action2"
@onready var item: Button = $"../../Options/Actions/ActionList/item"
@onready var defend: Button = $"../../Options/Actions/ActionList/defend"
@onready var attack: Button = $"../../Options/Actions/ActionList/attack"

var character = null

func enter() -> void:
	character = Global.get_current_player()
	item_display.hide()
	
	print("SUB ATTACK STATE")
	action_1.grab_focus()

func process_input(event: InputEvent):
	# change state based on ui input
	if action_2.has_focus():
		# move to sub attack 2 option
		print("SELECT SUB ATK 2")
		return sub_attack2_state
	elif attack.has_focus():
		return attack_state
	elif defend.has_focus():
		return defend_state
	elif item.has_focus():
		return item_state
	if Input.is_action_just_pressed("ui_accept"):
		# enter enemy select state
		# execute sub attack 1 and check turn
		print("character does sub attack 1")
		Global.queue_action(1)
		return enemy_select_state
		
	return null
