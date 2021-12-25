extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("stop_music", self, "end_level")
	Events.connect("open_menu", self, "open_menu")
	Events.connect("player_died", self, "player_died")
	$Button.hide()
	$text_window.hide()
	$current_level_name.hide()
	$current_level_number.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func end_level():
	$text_window.text = "LEVEL COMPLETED!!!"
	$text_window.show()


func _on_Button_pressed():
	get_tree().reload_current_scene()

func open_menu():
	if $Button.visible == true:
		$Button.hide()
	else:
		$Button.show()

func player_died():
	$text_window.text = "YOU DIED"
	$text_window.show()
	$Button.text = "RETRY"
	$Button.show()
