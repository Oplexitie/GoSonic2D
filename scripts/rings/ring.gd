extends Node2D

onready var score_manager = get_node("/root/ScoreManager") as ScoreManager

onready var sprite = $Sprite
onready var collider = $Area2D/CollisionShape2D
onready var ring_sparkle = $RingSparkle
onready var ring_audio = $RingAudio

func collect():
	ring_audio.play()
	ring_sparkle.play()
	sprite.visible = false
	score_manager.add_ring()
	collider.set_deferred("disabled", true)

func _on_Area2D_area_entered(area):
	var player = area.get_parent()
	
	if player is Player:
		collect()
