extends Node
# global access

var knight
var mage
var enemyA
var enemyB
var boss
var current_player: Player = null
var target_enemy = null
var turn_ended = false
var existing_enemies = []
var player_attack = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get the playable character nodes
	knight = get_node("/root/Battle/Knight")
	mage = get_node("/root/Battle/Mage")
	
	# get enemy nodes
	enemyA = get_node("/root/Battle/Options/Enemies/Enemy A Button/Enemy A")
	enemyB = get_node("/root/Battle/Options/Enemies/Enemy B Button/Enemy B")
	boss = get_node("/root/Battle/Options/Enemies/Boss Button/catBoss")
	
	# current enemies list
	existing_enemies = [enemyA, enemyB, boss]
	
	current_player = knight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_knight() -> Player:
	return knight
	
func get_mage() -> Player:
	return mage	
	
func get_current_player() -> Node:
	return current_player
	
func player_turn_end() -> bool:
	return turn_ended
	
func start_turn() -> void:
	current_player = knight
	
func end_turn() -> void:
	print("FROM GLOBAL, CURRENT PLAYER ", current_player)
	if current_player == knight:
		current_player = mage
	elif current_player == mage:
		current_player = knight
		print("OWARIIII")
		turn_ended = true
	
func get_current_actor() -> Node:
	# return which node is currently doiong action
	# currently returning a placeholder node but the actual one
	# should also include enemy nodes
	return get_current_player()
	
func enemy_list() -> Array:
	return existing_enemies
	
func queue_action(type: int) -> String:
	if type == 1:
		return "sub_atk_1"
	else: 
		return "sub_atk_2"
	
