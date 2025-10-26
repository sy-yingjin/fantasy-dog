extends Control

# code that shows the options UI

@onready var options_state_machine: Node = $OptionsStateMachine
@onready var character_name: Label = $Options/Actions/CharacterName

@onready var enemies: Control = $Enemies
@onready var enemy_arrow: TextureRect = $"Options/Options/Enemy Arrow"

@onready var attack: Button = $Options/Actions/ActionList/attack
@onready var defend: Button = $Options/Actions/ActionList/defend
@onready var item: Button = $Options/Actions/ActionList/item
@onready var action_1: Button = $Options/SubActions/SubActionList/action1
@onready var action_2: Button = $Options/SubActions/SubActionList/action2
@onready var other_buttons = [action_1, action_2, item, defend, attack]



var index: int = 0

func _ready() -> void:
	print("HEY ITS OPTIONS")
	# initialize options state machine
	character_name.text =  Global.current_player.get_character_name()
	options_state_machine.init(self)
	# displays the lists of actions and subactions
	var actions = $Options/Actions
	actions.show()
	var sub_actions = $Options/SubActions
	sub_actions.show()
	for button in get_enemies():
		button.set_focus_mode(FOCUS_NONE)
	
func _unhandled_input(event: InputEvent) -> void:
	options_state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	options_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	character_name.text =  Global.current_player.get_character_name()
	options_state_machine.process_frame(delta)
	# enable / diable enemy buttons depending on the state
	enemies_enable_select()
	
func get_enemies() -> Array:
	return enemies.get_children()
	
func enemies_enable_select() -> void:
	if options_state_machine.enemy_select():
		# disable other buttons 
		for b in other_buttons:
			b.focus_mode = Control.FOCUS_NONE
		
		# enable the focus on enemy buttons
		for b in enemies.get_children():
			b.focus_mode = Control.FOCUS_ALL
			print("focus on ", b)

		enemy_arrow.show()
	
