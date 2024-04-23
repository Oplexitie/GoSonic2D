extends Shield

class_name ThunderShield

export(float) var vertical_force = -330

onready var shield_sprite = $ShieldSprite
onready var shield_animation_player = $ShieldSprite/AnimationPlayer

func on_activate():
	shield_sprite.visible = true
	shield_animation_player.play("default")

func on_deactivate():
	shield_sprite.visible = false
	shield_animation_player.stop()

func on_action():
	shield_user.velocity.y = vertical_force
