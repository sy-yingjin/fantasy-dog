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

func get_character_name() -> StringName:
	return player_name

func get_Act(j: int) -> String:
	return atk_list[j]
		
func get_ActDesc(j: int) -> String:
	return atk_descriptions[j]

func defend() -> void:
	# do defense logic
	pass
	
func attack(type: int) -> void:
	if type == 1:
		# do type 1 attack
		print("player did ordinary attack")
	else:
		# do type 2 attack
		 #updateBar.emit() to update MP bar in UI
		print("player did mana attack")
	pass
		
func use_item() -> void:
	# do item logic here
	
	pass
	
func takeDamage(damage: float):
	currentHP -= damage
	
	isHurt = true # use this to do the blinking animation to indicate damage
	
	updateBar.emit()
	
	
