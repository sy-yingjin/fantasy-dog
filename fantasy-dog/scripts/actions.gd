class_name Action extends NinePatchRect

@onready var character_name: Label = $CharacterName
@onready var attack: Button = $VBoxContainer/attack
@onready var defend: Button = $VBoxContainer/defend
@onready var item: Button = $VBoxContainer/item

# select character

func _ready() -> void:
	character_name = #selected character
