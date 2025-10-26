class_name Player
extends Node

signal updateBar

var maxHP: float
var maxMP: float
var currentHP: float
var currentMP: float
var player_name: StringName
var atk_1
var atk_1_desc
var atk_2
var atk_2_desc
var def
var atk_list = [atk_1, atk_2]
var atk_descriptions = [atk_1_desc, atk_2_desc]
var isHurt
var animation
var executed_action
var animation_ended: bool = false
var action_done: bool = false

func get_character_name() -> StringName:
	return player_name

func get_Act(j: int) -> String:
	return atk_list[j]
		
func get_ActDesc(j: int) -> String:
	return atk_descriptions[j]

func defend() -> void:
	# do defense logic
	executed_action = "defend"
	pass
	
func attack(type: String) -> void:
	if type == "sub_atk_1":
		# do type 1 attack
		print("player did ordinary attack")
	else:
		# do type 2 attack
		 #updateBar.emit() to update MP bar in UI
		print("player did mana attack")
	pass
		
func use_item() -> void:
	# do item logic here
	# red bottle: heal HP
	# blue bottle: heal MP 
	# green bottle: poison HP
	# ham: heal both HP MP
	# bone: skip turn (got distracted)
	# flower: take down enemy defense ????
	# gun: damage enemy
	pass
	
func take_damage(damage: float):
	currentHP -= damage
	updateBar.emit()
	
func play_and_wait_for_animation(animation_name):
	animation.play(animation_name)
	
func finished_action() -> void:
	Global.queued_action = null
	# start a wait timer here
	pass
	
func used_MP(amount: float):
	currentMP -= amount
	updateBar.emit()
	
	
