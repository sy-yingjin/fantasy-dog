extends Node2D

var maxHP: float = 100.0
var currentHP: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHP = maxHP
	animated_sprite.play("default")


func is_alive() -> bool:
	return currentHP > 0.0


func take_damage(damage: float) -> void:
	currentHP = max(0.0, currentHP - damage)
	print(name, " HP: ", currentHP, "/", maxHP)
	animated_sprite.play("damage")
	# Animation will return to default automatically

	# Check for death
	if currentHP <= 0.0:
		die()


func heal(amount: float) -> void:
	currentHP = min(maxHP, currentHP + amount)
	print(name, " healed. HP: ", currentHP, "/", maxHP)
	animated_sprite.play("healing")


func decide_action() -> void:
	var boss = Global.boss

	# Check if boss exists and needs healing
	if boss and boss.is_alive():
		var boss_hp_ratio = boss.currentHP / boss.maxHP

		if boss_hp_ratio < 0.4:  # Boss HP below 40%
			boss.heal(15.0)
			animate(2)  # Play healing animation
			Global.declare("%s heals the Boss for 15 HP!" % name)
			return

	# Default action: Defend
	animate(1)  # Play defending animation
	Global.declare("%s is defending!" % name)


func animate(type: int) -> void:
	if type == 1:
		animated_sprite.play("defending")
	else:
		animated_sprite.play("healing")


func die() -> void:
	# Announce and disable selection for this enemy
	Global.declare("%s is defeated!" % name)
	# Disable and hide the parent button to prevent selection
	var btn := get_parent()
	if btn and btn is TextureButton:
		btn.disabled = true
		btn.visible = false
	# Inform Global so the mapping (index -> enemy) nulls out
	Global.remove_enemy(self)
	
