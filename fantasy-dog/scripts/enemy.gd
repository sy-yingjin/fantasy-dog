extends Node2D

var maxHP: float = 100.0
var currentHP: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHP = maxHP
	animated_sprite.play("default")
	# Connect animation_finished signal
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)


func is_alive() -> bool:
	return currentHP > 0.0


func _on_animated_sprite_animation_finished() -> void:
	# Return to default animation after damage, heal, or other animations finish
	if animated_sprite.animation in ["damage", "healing", "defending"]:
		print(name, " animation ", animated_sprite.animation, " finished, returning to default")
		animated_sprite.play("default")


func take_damage(damage: float) -> void:
	currentHP = max(0.0, currentHP - damage)
	print(name, " HP: ", currentHP, "/", maxHP)
	print(name, " taking damage, playing damage animation")
	animated_sprite.play("damage")

	# Check for death
	if currentHP <= 0.0:
		die()


func heal(amount: float) -> void:
	currentHP = min(maxHP, currentHP + amount)
	print(name, " healed. HP: ", currentHP, "/", maxHP)
	animate(2)
	Global.boss.animate(2)


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
	Global.boss.animate(1)
	Global.declare("%s is defending boss!" % name)


func animate(type: int) -> void:
	# Don't interrupt damage animation
	if animated_sprite.animation == "damage":
		return

	if type == 1:
		animated_sprite.play("defending")
	elif type == 2:
		animated_sprite.play("healing")
	else:
		animated_sprite.play("default")


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
	
