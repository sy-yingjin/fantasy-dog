class_name Player
extends Node

var HP
var MP
var player_name
var atk_1
var atk_1_desc
var atk_2
var atk_2_desc
var def
var atk_list = [atk_1, atk_2]
var atk_descriptions = [atk_1_desc, atk_2_desc]

func get_Act(j: int) -> String:
	return atk_list[j]
		
func get_ActDesc(j: int) -> String:
	return atk_descriptions[j]
