extends Control

# code that shows the options UI

@onready var options_state_machine: Node = $OptionsStateMachine
@onready var character_name: Label = $Options/Actions/CharacterName

@onready var enemies: Control = $Enemies
@onready var enemy_arrow: TextureRect = $"Enemy Arrow"

@onready var attack: Button = $Options/Actions/ActionList/attack
@onready var defend: Button = $Options/Actions/ActionList/defend
@onready var item: Button = $Options/Actions/ActionList/item
@onready var action_1: Button = $Options/SubActions/SubActionList/action1
@onready var action_2: Button = $Options/SubActions/SubActionList/action2
@onready var other_buttons = [action_1, action_2, item, defend, attack]



var index: int = 0
var _initialized: bool = false

func _ready() -> void:
	print("HEY ITS OPTIONS")

	# Wait for Global to finish initialization
	await get_tree().process_frame
	await get_tree().process_frame  # Extra frame to ensure Global._ready() completes

	# Additionally, wait until Global has a valid current_player (handles scene reloads)
	var tries := 0
	while (Global == null or not is_instance_valid(Global.current_player)) and tries < 60:
		# Ask Global to rebind if needed
		if Global and Global.has_method("rebind_scene_nodes"):
			Global.rebind_scene_nodes()
		await get_tree().process_frame
		tries += 1

	# initialize options state machine only when a valid player exists
	if is_instance_valid(Global.current_player):
		_init_state_machine()
	else:
		character_name.text = ""
	
func _unhandled_input(event: InputEvent) -> void:
	options_state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	options_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	# Lazy-init if we weren't ready during _ready(); attempt rebind as needed
	if not _initialized and (Global and Global.has_method("rebind_scene_nodes")):
		if not is_instance_valid(Global.current_player):
			Global.rebind_scene_nodes()
	if not _initialized and is_instance_valid(Global.current_player):
		_init_state_machine()
	if is_instance_valid(Global.current_player):
		character_name.text = Global.current_player.get_character_name()
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
	else:
		for b in other_buttons:
			b.focus_mode = Control.FOCUS_ALL
		for b in enemies.get_children():
			b.focus_mode = Control.FOCUS_NONE
		

func _init_state_machine() -> void:
	if _initialized:
		return
	_initialized = true
	# initialize options state machine
	if is_instance_valid(Global.current_player):
		character_name.text = Global.current_player.get_character_name()
	else:
		character_name.text = ""
	options_state_machine.init(self)
	# displays the lists of actions and subactions
	var actions = $Options/Actions
	actions.show()
	var sub_actions = $Options/SubActions
	sub_actions.show()
	for button in get_enemies():
		button.set_focus_mode(FOCUS_NONE)
	
