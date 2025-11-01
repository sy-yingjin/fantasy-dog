extends Node2D

var maxHP: float = 200.0  # Boss has more HP
var currentHP: float = 200.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var atk_fx: AnimatedSprite2D = $atk_fx


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHP = maxHP
	animated_sprite.play("default")


func is_alive() -> bool:
	return currentHP > 0.0


func take_damage(damage: float) -> void:
	currentHP = max(0.0, currentHP - damage)
	print("Boss HP: ", currentHP, "/", maxHP)
	animated_sprite.play("damage")

	if currentHP <= 0.0:
		die()


func heal(amount: float) -> void:
	currentHP = min(maxHP, currentHP + amount)
	print("Boss healed. HP: ", currentHP, "/", maxHP)
	animated_sprite.play("healed")


func choose_attack() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# 45% chance single target, 55% chance AoE
	if rng.randi_range(0, 100) < 45:
		attack_single()
	else:
		attack_all()


func attack_single() -> void:
	attack(1)  # Play single target animation

	# Get alive players
	var targets := [Global.get_knight(), Global.get_mage()]
	var alive := targets.filter(func(p): return p and p.currentHP > 0.0)

	if alive.size() == 0:
		return  # No targets available

	# Pick random alive player
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var target: Player = alive[rng.randi_range(0, alive.size() - 1)]

	var dmg := 18.0
	target.take_damage(dmg)
	var actual := int(target.get_last_damage_taken()) if (target and target.has_method("get_last_damage_taken")) else int(dmg)
	Global.declare("Boss hits %s for %d HP!" % [target.get_character_name(), actual])


func attack_all() -> void:
	attack(2)  # Play AoE animation

	var dmg := 12.0
	var targets := [Global.get_knight(), Global.get_mage()]

	var parts: Array[String] = []
	for target in targets:
		if target and target.currentHP > 0.0:
			target.take_damage(dmg)
			var actual := int(target.get_last_damage_taken()) if (target and target.has_method("get_last_damage_taken")) else int(dmg)
			parts.append("%s: %d" % [target.get_character_name(), actual])

	if parts.size() > 0:
		var msg: String = "Boss hits everyone! " + parts[0]
		for i in range(1, parts.size()):
			msg += ", " + parts[i]
		Global.declare(msg)


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


func die() -> void:
	Global.declare("Boss is defeated!")
	# Disable and hide the parent button to prevent selection
	var btn := get_parent()
	if btn and btn is TextureButton:
		btn.disabled = true
		btn.visible = false
	# Inform Global so the mapping (index -> enemy) nulls out
	Global.remove_enemy(self)
