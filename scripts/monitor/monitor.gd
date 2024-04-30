extends Node2D
class_name Monitor

const BUMP_FORCE = 150
const GRAVITY = 700
const GROUND_DISTANCE = 16

export(Resource) var monitor_ressoure
export(int, LAYERS_2D_PHYSICS) var ground_layer = 1

onready var tree = get_tree()
onready var world = get_world_2d()
onready var score_manager = get_node("/root/ScoreManager") as ScoreManager

onready var icon = $Icon
onready var explosion = $Explosion0
onready var jingle_player = $JingleAudio
onready var explosion_audio = $ExplosionAudio

onready var solid_object = $SolidObject
onready var animation_tree = $Sprite/AnimationTree

var velocity: Vector2
var allow_movement: bool

func _ready():
	icon.frame = monitor_ressoure.monitor_icon
	jingle_player.stream = monitor_ressoure.jingle_audio

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
	explosion_audio.play()
	solid_object.set_enabled(false)
	animation_tree.set("parameters/state/current", 1)

func handle_item(player : Player):
	destroy()
	yield(tree.create_timer(0.5), "timeout")
	jingle_player.play()
	score_manager.add_score(monitor_ressoure.score)
	score_manager.add_ring(monitor_ressoure.rings)
	score_manager.add_life(monitor_ressoure.lifes)
	if(monitor_ressoure.shield_type): player.shields.change(monitor_ressoure.shield_type)

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
