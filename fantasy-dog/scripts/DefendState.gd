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

	# Safety check for character
	if not character:
		push_error("Character is null in DefendState.enter()")
		return

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
		if character:
			# Queue the defend action instead of executing immediately
			Global.add_action_to_queue(character, "defend", null)
			Global.declare("%s will defend!" % character.get_character_name())
			print("Character queued defend!")
			# action queued, move to next turn
			defend.focus_mode = Control.FOCUS_ALL

			# Move to next character or execution phase
			Global.end_turn()
			if !Global.player_turn_end():
				# Next character's turn
				return attack_state
			else:
				# Both characters selected, move to execution phase
				return enemy_state

func process_frame(delta: float):
	return null
