extends KinematicBody2D


signal swung(strength)

enum State {
	NORMAL,
	CHARGE,
	SWING,
}

export(int) var speed = 200
export(int) var strength_increase_rate = 1000

var _velocity = Vector2()
var _state = State.NORMAL
var _strength = 0

onready var _sprite = $AnimatedSprite


func _physics_process(delta):
	_handle_swing_input()
	
	match _state:
		State.NORMAL:
			_handle_movement()
			_velocity = move_and_slide(_velocity)
			_handle_run_animation()
			_look_at_mouse()
		
		State.CHARGE:
			_strength += strength_increase_rate * delta
			_handle_pre_swing()
			_look_at_mouse()
		
		State.SWING:
			pass


func _handle_movement():
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


func _handle_run_animation():
	_sprite.animation = "run"
	if _velocity.length() == 0:
		_sprite.stop()
		_sprite.frame = 0
	elif not _sprite.playing:
		_sprite.play()


func _handle_swing_input():
	if Input.is_action_just_pressed("swing"):
		_state = State.CHARGE
		_strength = 0
		_sprite.animation = "pre-swing"
		_sprite.stop()
	elif Input.is_action_just_released("swing"):
		_state = State.SWING
		_sprite.play("swing")
		emit_signal("swung", _strength)
		


func _handle_pre_swing():
	if _strength >= 2000:
		_sprite.frame = 2
	elif _strength >= 1000:
		_sprite.frame = 1
	else:
		_sprite.frame = 0


func _look_at_mouse():
	var mouse = get_viewport().get_mouse_position()
	_sprite.rotation = global_position.direction_to(mouse).angle() + PI / 2


func _on_AnimatedSprite_animation_finished():
	match _sprite.animation:
		"swing":
			_sprite.play("run")
			_state = State.NORMAL
