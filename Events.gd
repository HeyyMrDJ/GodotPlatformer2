extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_jump()
signal player_attacked(collider)
signal end_level()
signal stop_music()
signal open_menu()
signal player_died()

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("end_level", self, "end_level")
	Events.connect("player_died", self, "player_died")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func end_level():
	print("Level Completed")
	emit_signal("stop_music")
func open_menu():
	emit_signal("open_menu")
	
func player_died():
	emit_signal("stop_music")
