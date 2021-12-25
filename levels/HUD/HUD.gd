extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("stop_music", self, "end_level")
	Events.connect("open_menu", self, "open_menu")
	Events.connect("player_died", self, "player_died")
	Events.connect("end_game", self, "end_game")
	$restart_button.hide()
	$text_window.hide()
	$next_level_button.hide()
	$current_level_name.hide()
	$current_level_number.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func end_level():
	$text_window.text = "LEVEL COMPLETED!!!"
	$text_window.show()
	print(get_tree().current_scene)


func _on_Button_pressed():
	get_tree().reload_current_scene()

func open_menu():
	$restart_button.text = "RESTART LEVEL"
	if $restart_button.visible == true:
		$restart_button.hide()
	else:
		$restart_button.show()

func player_died():
	$text_window.text = "YOU DIED"
	$text_window.show()
	$restart_button.text = "RETRY"
	$restart_button.show()

func end_game():
	$text_window.text = "YOU HAVE CONQUERED THE BOSS AND IT'S MINIONS. THE WORLD IS NOW SAFE AGAIN!!!"
	$text_window.show()
	$next_level_button.text = "RESTART GAME"
	$next_level_button.show()


func _on_next_level_button_pressed():
	Events.next_level()


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
