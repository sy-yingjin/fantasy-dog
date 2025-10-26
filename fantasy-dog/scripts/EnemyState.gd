class_name EnemyState
extends State

@export var attack_state: State

@onready var actions: Control = $"../../Options/Actions"
@onready var sub_actions: Control = $"../../Options/SubActions"
@onready var enemy_arrow: TextureRect = $"../../Enemy Arrow"
@onready var menu_cursor: TextureRect = $"../../MenuCursor"



func enter() -> void:
	# hide options
	actions.hide()
	sub_actions.hide()
	enemy_arrow.hide()
	menu_cursor.hide()
	
	

	#
## do whatever enemy stuffs are needed
## make sure to update global value of the turn
#func physics_process(delta: float) -> State:
	## do whatever enemies do
	#
	## when everything is done set player turn to false to start player turn
	#Global.turn_ended = false
	#
	## check if enemy turn ends
	#if !Global.player_turn_end():
		#print("KNIGHT'S TURN")
		#return attack_state
	#else:
		#return null
