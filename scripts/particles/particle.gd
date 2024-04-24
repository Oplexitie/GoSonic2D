extends Sprite

class_name Particle

export(String) var animation_name = "default"

onready var animation_player = $AnimationPlayer

func play():
	visible = true
	animation_player.play(animation_name)

func stop():
	visible = false
	queue_free()

func _on_AnimationPlayer_animation_finished(_anim_name):
	stop()
