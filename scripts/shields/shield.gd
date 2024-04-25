extends Node2D

class_name Shield

export(bool) var invincible = true
export(bool) var ring_protection = true

export(NodePath) var action_audio_path

var action_audio : AudioStreamPlayer

var active: bool
var shield_user

func _ready():
	if action_audio_path: action_audio = get_node(action_audio_path)

func activate(player):
	if not active:
		active = true
		shield_user = player
		on_activate()

func deactivate():
	if active:
		active = false
		on_deactivate()

func action():
	if active:
		if action_audio:
			action_audio.play()
		on_action()

func on_activate():
	pass

func on_deactivate():
	pass

func on_action():
	pass

func cancel_action():
	pass
