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
var is_defending: bool = false
var last_damage_taken: float = 0.0

func get_character_name() -> StringName:
	return player_name

func get_Act(j: int) -> String:
	return atk_list[j]
		
func get_ActDesc(j: int) -> String:
	return atk_descriptions[j]

func defend() -> void:
	# do defense logic
	executed_action = "defend"
	is_defending = true
	# Visual/animation is handled by subclasses
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
	# Apply defend mitigation if active
	var final_damage := damage
	if is_defending:
		final_damage *= 0.5
	last_damage_taken = final_damage
	currentHP = max(0.0, currentHP - final_damage)
	updateBar.emit()
	if currentHP <= 0.0:
		die()

func is_alive() -> bool:
	return currentHP > 0.0
	
func play_and_wait_for_animation(animation_name):
	animation.play(animation_name)
	
func finished_action() -> void:
	Global.queued_action = null
	# start a wait timer here
	pass
	
func used_MP(amount: float):
	currentMP -= amount
	updateBar.emit()

# Clear defending state (called after enemies/boss finish their turn)
func clear_defend() -> void:
	is_defending = false

func get_last_damage_taken() -> float:
	return last_damage_taken


# Handle player defeat: notify Global (subclasses can also hide themselves)
func die() -> void:
	currentMP = 0
	updateBar.emit()
	
	# Announce defeat
	if Global and Global.has_method("declare"):
		Global.declare("%s is defeated!" % get_character_name())
	
	# Trigger end-of-battle check
	if Global and Global.has_method("check_battle_end"):
		Global.check_battle_end()
		
	Global.player_dead(self)
	queue_free()
	
	
