class_name Player
extends Node

var player_name
var atk_1
var atk_1_desc
var atk_2
var atk_2_desc
var def_1
var def_1_desc
var def_2
var def_2_desc

var atk_list = [atk_1, atk_2]
var def_list = [def_1, def_2]
var atk_descriptions = [atk_1_desc, atk_2_desc]
var def_descriptions = [def_1_desc, def_2_desc]

func get_Act(i: int, j: int) -> String:
	if i == 1:
		return atk_list[j]
	else:
		return def_list[j] 
		
func get_ActDesc(i: int, j: int) -> String:
	if i == 1:
		return atk_descriptions[j]
	else:
		return def_descriptions[j] 
