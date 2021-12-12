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
	if attacking:
		velocity.x = 0
		return
	if state_machine.get_current_node() == "Idle":
		attacking = false
	if is_on_floor() and velocity.x == 0:
		state_machine.travel("Idle")
	if Input.is_action_pressed("attack"):
			#attacking = true
		state = state_machine.get_current_node()
		$Music/Swing.play()
		print(state)
		if state == "Idle":
			state_machine.travel("Attack1")
		if state == "Attack1":
			state_machine.travel("Attack2")
			attacking = false
		if state == "Attack2":
			state_machine.travel("Attack3")
			attacking = false
	if !Input.is_action_pressed("move_left") or !Input.is_action_pressed("move_right"):
		velocity.x = 0
		attacking = false

	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		$Sprite.flip_h = velocity.x < 0
		$Sprite/Particles2D.rotation_degrees = 90
		if Input.is_action_pressed("run"):
			velocity.x *= 1.5
		if is_on_floor():
			state_machine.travel("Run")
			if Input.is_action_pressed("run"):
				velocity.x *= 1.5
			
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		$Sprite.flip_h = false
		$Sprite/Particles2D.rotation_degrees = -90
		if is_on_floor():
			state_machine.travel("Run")
			if Input.is_action_pressed("run"):
				velocity.x *= 1.5
			
	if Input.is_action_pressed("jump"):
		if is_on_floor(): #or is_on_wall()
			velocity.y = jump_speed
			jumping = true
			$Music/Jump.play()
			state_machine.travel("Jump")
			
	if Input.is_action_pressed("move_down"):
		if is_on_floor():
			state_machine.travel("Crouch")
	
	if Input.is_action_just_pressed("attack2"):
		#$Music/Cast.play()
		pass
	
	if Input.is_action_pressed("attack2"):
		state_machine.travel("Cast")
		

func animation_started(anim_name):
	print(anim_name + " Attacking")
	attacking = true

func animation_finished(anim_name):
	print(anim_name + " Not attacking")
	attacking = false


func _on_Timer_timeout():
	attacking = false # Replace with function body.
