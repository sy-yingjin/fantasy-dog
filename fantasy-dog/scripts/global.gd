extends Node
# global access

var knight = null
var mage = null
var current_player = null
var turn_ended = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get the playable character nodes
	knight = get_node("/root/Battle/Knight")
	mage = get_node("/root/Battle/Mage")
	# mage = get_node("/root/Battle/Mage")
	current_player = knight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_knight() -> Player:
	return knight
	
func get_mage() -> Player:
	return mage

func set_current_player(character: Player) -> void:
	current_player = character
	
func get_current_player() -> Node:
	return current_player
	
func player_turn_end() -> bool:
	return turn_ended
	
func start_turn() -> void:
	set_current_player(knight)
	
func next_player() -> void:
	set_current_player(mage)
	
func get_current_actor() -> Node:
	# return which node is currently doiong action
	# currently returning a placeholder node but the actual one
	# should also include enemy nodes
	return get_current_player()
