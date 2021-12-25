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
signal end_game()

var current_level = "level1"

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
	current_level = str(get_tree().current_scene.name)
	if current_level == "Level4":
		end_game()
		yield(get_tree().create_timer(26.0), "timeout")
		
	yield(get_tree().create_timer(6.0), "timeout")
	next_level()
	
func open_menu():
	emit_signal("open_menu")
	
func player_died():
	emit_signal("stop_music")
	
func next_level():
	current_level = str(get_tree().current_scene.name)
	var next_level
	print(current_level)
	if current_level == "Level1":
		next_level = "Level2"
	if current_level == "Level2":
		next_level = "Level3"
	if current_level == "Level3":
		next_level = "Level4"
	if current_level == "Level4":
		next_level = "Level1"
	else:
		print("IDK WHAT LEVEL THIS IS")
	print(next_level)
	current_level = next_level
	print(get_tree().current_scene.name)
	print(current_level)
	get_tree().change_scene("res://levels/"+next_level+".tscn")
	
func end_game():
	emit_signal("end_game")
