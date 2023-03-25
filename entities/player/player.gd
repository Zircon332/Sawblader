extends KinematicBody2D


export(int) var speed = 200

var _velocity = Vector2()
onready var _sprite = $AnimatedSprite


func _physics_process(delta):
	_get_input()
	_velocity = move_and_slide(_velocity)
	_look_at_mouse()


func _get_input():
	_velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		_velocity.x += 1
	if Input.is_action_pressed("move_left"):
		_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		_velocity.y += 1
	if Input.is_action_pressed("move_up"):
		_velocity.y -= 1
	_velocity = _velocity.normalized() * speed


func _look_at_mouse():
	var mouse = get_viewport().get_mouse_position()
	_sprite.rotation = global_position.direction_to(mouse).angle() + PI / 2
