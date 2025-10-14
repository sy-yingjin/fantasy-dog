extends Node
# global access

var knight = null
var mage = null
var game_state = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get the playable character nodes
	knight = get_tree().get_first_node_in_group("Players") 
	mage = get_tree().get_second_node_in_group("Players")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_knight() -> Player:
	return knight
	
func get_mage() -> Player:
	return mage
