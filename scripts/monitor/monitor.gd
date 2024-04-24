tool
extends Node2D

class_name Monitor

const BUMP_FORCE = 150
const GRAVITY = 700
const GROUND_DISTANCE = 16

export(int, "Ring",
	"Combine Ring",
	"Speed Shoes",
	"Invicibility Shield",
	"Blue Shield",
	"Thunder Shield",
	"Flame Shield",
	"Bubble Shield",
	"Super Sonic",
	"Egg Monitor",
	"1Up") var monitor_type setget ,_ready
export(int, LAYERS_2D_PHYSICS) var ground_layer = 1

onready var tree
onready var world
onready var score_manager

onready var icon = $Icon
onready var explosion = $Explosion0
onready var monitor_audio = {"Jingle": $JingleAudio, "Explosion": $ExplosionAudio}

onready var solid_object = $SolidObject
onready var animation_tree = $Sprite/AnimationTree

var velocity: Vector2
var allow_movement: bool

func _ready():
	icon.frame = monitor_type
	if Engine.editor_hint:
		return monitor_type
	else:
		tree = get_tree()
		world = get_world_2d()
		score_manager = get_node("/root/ScoreManager") as ScoreManager
		
	match monitor_type:
		0: 	monitor_audio["Jingle"].stream = preload("res://audios/effects/ring.wav")
		10: monitor_audio["Jingle"].stream = preload("res://audios/effects/yes.wav")

func _physics_process(delta):
	if allow_movement:
		handle_movement(delta)
		handle_collision()

func handle_movement(delta: float):
	velocity.y += GRAVITY * delta
	position += velocity * delta

func handle_collision():
	var ground_hit = GoPhysics.cast_ray(world, position, transform.y, 
		GROUND_DISTANCE, [solid_object], ground_layer)
	
	if ground_hit:
		allow_movement = false
		velocity = Vector2.ZERO
		position.y -= ground_hit.penetration
		position = position.round()

func destroy():
	explosion.play()
	icon.set_movement(true)
	monitor_audio["Explosion"].play()
	solid_object.set_enabled(false)
	animation_tree.set("parameters/state/current", 1)

func handle_item(player : Player):
	destroy()
	yield(tree.create_timer(0.5), "timeout")
	monitor_audio["Jingle"].play()
	match monitor_type:
		1: score_manager.add_ring(10)
		4: player.shields.change("BlueShield")
		5: player.shields.change("ThunderShield")
		6: player.shields.change("FlameShield")
		7: player.shields.change("BubbleShield")
		10: score_manager.add_life(1)

func bump_up():
	allow_movement = true
	velocity.y = -BUMP_FORCE

func _on_SolidObject_player_ceiling_collision(player: Player):
	if player.velocity.y <= 0:
		bump_up()

func _on_SolidObject_player_ground_collision(player: Player):
	if player.is_rolling and player.velocity.y > 0:
		player.velocity.y = -player.velocity.y
		player.shields.cancel_current()
		handle_item(player)

func _on_SolidObject_player_wall_collision(player: Player):
	if player.is_grounded() and player.is_rolling:
		handle_item(player)
