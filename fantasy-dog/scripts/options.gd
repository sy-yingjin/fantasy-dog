extends Control

# code that shows the options UI

@onready var options_state_machine: Node = $OptionsStateMachine
@onready var character_name: Label = $Actions/CharacterName

var index: int = 0

func _ready() -> void:
	print("HEY ITS OPTIONS")
	# initialize options state machine
	character_name.text =  Global.current_player.get_character_name()
	options_state_machine.init(self)
	# displays the lists of actions and subactions
	var actions = $Actions
	actions.show()
	var sub_actions = $SubActions
	sub_actions.show()
	
func _unhandled_input(event: InputEvent) -> void:
	options_state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	options_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	character_name.text =  Global.current_player.get_character_name()
	options_state_machine.process_frame(delta)
