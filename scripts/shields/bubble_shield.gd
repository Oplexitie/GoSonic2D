extends Shield

export(float) var down_force = 480
export(float) var bounce_force = 450
export(float) var min_bounce_force = 240

onready var shield_sprite = $ShieldSprite
onready var effect_sprite = $EffectSprite

onready var shield_animation_player = $ShieldSprite/AnimationPlayer
onready var effect_animation_player = $EffectSprite/AnimationPlayer

var is_bouncing = false

func on_activate():
	is_bouncing = false
	shield_user.connect("ground_enter", self, "on_user_ground_enter")
	shield_sprite.visible = true
	effect_sprite.visible = true
	shield_animation_player.play("default")
	effect_animation_player.play("default")

func on_deactivate():
	shield_sprite.visible = false
	effect_sprite.visible = false
	shield_animation_player.stop()
	effect_animation_player.stop()

func on_action():
	shield_user.velocity.x /= 2
	shield_user.velocity.y += down_force
	
	shield_animation_player.play("bounce")
	is_bouncing = true
	effect_sprite.visible = false

func on_user_ground_enter():
	if is_bouncing:
		shield_animation_player.play("bounce_back")
		is_bouncing = false
		action_audio.play()
		shield_user.is_jumping = true
		shield_user.is_rolling = true
		
		var ground_angle = -shield_user.ground_normal.angle_to(Vector2.UP)
		if Input.is_action_pressed("player_a"):
			shield_user.velocity.x -= bounce_force * sin(ground_angle)
			shield_user.velocity.y -= bounce_force * cos(ground_angle)
		else:
			shield_user.velocity.x -= min_bounce_force * sin(ground_angle)
			shield_user.velocity.y -= min_bounce_force * cos(ground_angle)

func cancel_action():
	if is_bouncing:
		shield_animation_player.play("bounce_back")
		is_bouncing = false

func _on_bubble_bounce_finished(anim_name):
	if anim_name == "bounce_back":
		effect_animation_player.stop()
		effect_sprite.visible = true
		effect_animation_player.play("default")
		shield_animation_player.play("default")
