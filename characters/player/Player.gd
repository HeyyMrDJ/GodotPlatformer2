extends KinematicBody2D

export (int) var speed = 400
export (int) var jump_speed = -1200
export (int) var gravity = 4000

var velocity = Vector2.ZERO
var jumping : bool
var state_machine
var attacking : bool
var state
# Called when the node enters the scene tree for the first time.
func _ready():
	attacking = false
# warning-ignore:return_value_discarded
	Events.connect("player_jump", self, "player_jump")
	Events.connect("stop_music", self, "stop_music")
	state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	get_input()
	#velocity.x = velocity.x /10
	#if abs(velocity.x) > 1:
		#velocity.x = 0
	if velocity.y > 0:
		state_machine.travel("Falling")
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if velocity.y > 0:
		pass
	
	if is_on_floor():
		if jumping == true:
			state_machine.travel("Landing")
			jumping = false
	
func get_input():
	#stuff = state_machine.get_current_node()
	#print(stuff)
	if Input.is_action_just_pressed("open_menu"):
		Events.open_menu()
		
	if attacking:
		velocity.x = 0
		return
	if state_machine.get_current_node() == "Idle":
		attacking = false
	if is_on_floor() and velocity.x == 0:
		state_machine.travel("Idle")
	if Input.is_action_pressed("attack"):
			#attacking = true
			
		check_slash()
		state = state_machine.get_current_node()
		print(state)
		if state == "Idle":
			check_slash()
			state_machine.travel("Attack1")
		if state == "Attack1":
			check_slash()
			state_machine.travel("Attack2")
			attacking = false
			$Music/Swing.play()
		if state == "Attack2":
			check_slash()
			state_machine.travel("Attack3")
			attacking = false
			$Music/Swing.play()
	if !Input.is_action_pressed("move_left") or !Input.is_action_pressed("move_right"):
		velocity.x = 0
		attacking = false

	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		$Sprite.flip_h = velocity.x < 0
		$Sprite/Particles2D2.rotation_degrees = 90
		$raycast_cast.rotation_degrees = 90
		$raycast_slash.rotation_degrees = 90
		if Input.is_action_pressed("run"):
			velocity.x *= 1.5
		if is_on_floor():
			state_machine.travel("Run")
			if Input.is_action_pressed("run"):
				velocity.x *= 1.5
			
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		$Sprite.flip_h = false
		$Sprite/Particles2D2.rotation_degrees = -90
		$raycast_cast.rotation_degrees = -90
		$raycast_slash.rotation_degrees = -90
		if is_on_floor():
			state_machine.travel("Run")
			if Input.is_action_pressed("run"):
				velocity.x *= 1.5
			
	if Input.is_action_pressed("jump"):
		if is_on_floor(): #or is_on_wall()
			velocity.y = jump_speed
			jumping = true
			state_machine.travel("Jump")
			
	if Input.is_action_pressed("move_down"):
		if is_on_floor():
			state_machine.travel("Crouch")
	
	if Input.is_action_just_pressed("attack2"):
		#$Music/Cast.play()
		pass
	
	if Input.is_action_pressed("attack2"):
		state_machine.travel("Cast")
		check_cast()
		
	if Input.is_action_pressed("test"):
		#player_jump()
		check_slash()
		
			
		
func animation_started(anim_name):
	print(anim_name + " Attacking")
	attacking = true

func animation_finished(anim_name):
	print(anim_name + " Not attacking")
	attacking = false


func _on_Timer_timeout():
	attacking = false # Replace with function body.


func _on_player_bottom_area_entered(_area):
	if is_in_group("Enemy"):
		print("Enemy")
	pass # Replace with function body.


func _on_player_bottom_body_entered(_body):
	if is_in_group("Enemy"):
		print("Enemy")
	pass # Replace with function body.
	
func player_jump():
	velocity.y = jump_speed
	jumping = true
	state_machine.travel("Jump")

func check_cast():
	if $raycast_cast.is_colliding():
		print("Attack")
		var collider = $raycast_cast.get_collider().get_name()
		print(collider)
		yield(get_tree().create_timer(0.5), "timeout")
		Events.emit_signal("player_attacked", collider)
		
func check_slash():
	if $raycast_slash.is_colliding():
		print("Attack")
		var collider = $raycast_cast.get_collider().get_name()
		#print(collider)
		Events.emit_signal("player_attacked", collider)
	

func stop_music():
	#queue_free()
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		player_died()

func player_died():
	Events.emit_signal("player_died")
	queue_free()
