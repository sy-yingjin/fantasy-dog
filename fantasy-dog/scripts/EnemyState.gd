class_name EnemyState
extends State

@export var attack_state: State

@onready var actions: Control = $"../../Actions"
@onready var sub_actions: Control = $"../../SubActions"

func _ready() -> void:
	# hide options
	actions.hide()
	sub_actions.hide()
	
# do whatever enemy stuffs are needed
# make sure to update global value of the turn
func physics_process(delta: float) -> State:
	# do whatever enemies do
	
	
	# check if enemy turn ends
	if !Global.player_turn_end():
		print("KNIGHT'S TURN")
		return attack_state
	else:
		return null
