extends Control

# code that shows the options UI

@onready var options_state_machine: Node = $OptionsStateMachine
@onready var character_name: Label = $Options/Actions/CharacterName
@onready var enemies: Control = $Enemies
@onready var enemy_arrow: TextureRect = $"Options/Options/Enemy Arrow"

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
	
func get_enemies() -> Array:
	return enemies.get_children()
	
func enemies_enable_select() -> void:
	var mode: FocusMode = FocusMode.FOCUS_ALL if options_state_machine.enemy_select() else FocusMode.FOCUS_NONE
	for button in get_enemies():
		button.set_focus_mode(mode)
	print("MOVE")
	if options_state_machine.enemy_select():
		enemy_arrow.show()
		pass
	
