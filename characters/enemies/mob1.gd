extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -1200
export (int) var gravity = 4000

var state_machine

var velocity = Vector2.ZERO
#signal player_jumped

func _ready():
	Events.connect("player_attacked", self, "player_attacked")

func get_input():
	velocity.x = 0
	velocity.x += speed
	if velocity.x == 0:
		speed = speed * -1
	#DEBUG print(speed)
	#if Input.is_action_pressed("move_left"):
		#velocity.x -= speed
	if $raycast_left.is_colliding():
		#$CollisionShape2D.position.x *= -1
		#DEBUG print("Left")
		speed = 200
	if $raycast_right.is_colliding():
		#DEBUG print("Right")
		#DEBUG print($raycast_left.get_collider())
		speed = -200
	if $raycast_top.is_colliding():
		print($raycast_top.get_collider())
		$AnimationPlayer.play("Ouch")
		Events.emit_signal("player_jump")
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
	
	#if is_on_wall():
		#speed = speed * -1


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func player_attacked(collider):
	
	if self.name == collider:
		$CollisionShape2D.disabled = true
		$AnimationPlayer.play("Ouch")
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		Events.emit_signal("player_jump")
		$AnimationPlayer.play("Ouch")
		#Why doesn't this work?
		#$CollisionShape2D.disabled = true
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
