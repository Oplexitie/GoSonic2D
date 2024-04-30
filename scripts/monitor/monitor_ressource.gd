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
	"1Up") var monitor_icon

export(String, "BlueShield", "ThunderShield", "FlameShield", "BubbleShield") var shield_type

export(AudioStream) var jingle_audio

export(int) var score
export(int) var rings
export(int) var lifes
