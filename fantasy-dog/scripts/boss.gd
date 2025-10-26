extends Node2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var atk_fx: AnimatedSprite2D = $atk_fx


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var maxHP = 100
	animated_sprite.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	If the Boss' health is low, enemy will prioritize healing
#	else, just keep defending.
	pass
	
func animate(type: int) -> void:
	if type == 1:
		animated_sprite.play("defend")
	elif type == 2:
		animated_sprite.play("healed")
	else:
		animated_sprite.play("damage")
	
func attack(type: int) -> void:
	if type == 1:
		atk_fx.play("atk_one")
	else:
		atk_fx.play("atk_all")
