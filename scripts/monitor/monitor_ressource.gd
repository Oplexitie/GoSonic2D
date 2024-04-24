extends Resource
class_name Monitor_Ressource

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

var shield_type : String

export(AudioStream) var jingle_audio

export(int) var score
export(int) var rings
export(int) var lifes

func _ready():
	match monitor_type:
		4: shield_type = "BlueShield"
		5: shield_type = "ThunderShield"
		6: shield_type = "FlameShield"
		7: shield_type = "BubbleShield"
	return monitor_type
