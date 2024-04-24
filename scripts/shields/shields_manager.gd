extends Node2D

class_name ShieldsManager

onready var shields = {
	"None": null,
	"InstaShield": $InstaShield,
	"BlueShield": $BlueShield,
	"ThunderShield": $ThunderShield,
	"FlameShield": $FlameShield,
	"BubbleShield": $BubbleShield
}

onready var shield_user = get_parent()
onready var default_shield = "InstaShield"

var current_shield: Shield

func _ready():
	change(default_shield)

func change(to: String):
	if current_shield:
		current_shield.deactivate()
	
	current_shield = shields[to]
	current_shield.activate(shield_user)

func change_to_default():
	change(default_shield)

func use_current():
	if current_shield:
		current_shield.action()

func cancel_current():
	if current_shield == shields.BubbleShield:
		current_shield.cancel_action()
