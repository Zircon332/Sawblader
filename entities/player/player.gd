extends KinematicBody2D


signal swung(strength)
signal dead

enum State {
	NORMAL,
	CHARGE,
	SWING,
	FROZEN,
}

const BloodScene = preload("res://particles/blood_radial.tscn")

export(int) var speed = 200
export(int) var walk_speed = 100
export(int) var strength_increase_rate = 5000
export(int) var max_strength = 9999

var _velocity = Vector2()
var _state = State.NORMAL
var _strength = 0

onready var world = get_viewport().get_node("Main")
onready var _sprite = $AnimatedSprite
onready var _hitbox = $HitBox
onready var _speed = speed


func _process(delta):
	var maxed = _state == State.CHARGE and _strength == max_strength
	_sprite.position = Vector2.RIGHT.rotated(rand_range(0, TAU)) * 1 if maxed else Vector2.ZERO


func _physics_process(delta):
	if _state == State.FROZEN:
		return
	
	_handle_swing_input()
	
	match _state:
		State.NORMAL:
			_handle_movement()
			_velocity = move_and_slide(_velocity)
			_handle_run_animation()
			_look_at_mouse()
		
		State.CHARGE:
			_handle_movement()
			_velocity = move_and_slide(_velocity)
			
			_strength = min(_strength + strength_increase_rate * delta, max_strength)
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
		
	_velocity = _velocity.normalized() * _speed


func _handle_run_animation():
	_sprite.animation = "run"
	if _velocity.length() == 0:
		_sprite.stop()
		_sprite.frame = 0
	elif not _sprite.playing:
		_sprite.play()


func _handle_swing_input():
	if Input.is_action_just_pressed("swing") and _state == State.NORMAL:
		_state = State.CHARGE
		_strength = 0
		_speed = walk_speed
		_sprite.animation = "pre-swing"
		_sprite.stop()
	elif Input.is_action_just_released("swing") and _state == State.CHARGE:
		_state = State.SWING
		_hitbox.set_deferred("monitoring", true)
		_sprite.play("swing")
		emit_signal("swung", _strength)


func _handle_pre_swing():
	if _strength >= max_strength * 0.67:
		_sprite.frame = 2
	elif _strength >= max_strength * 0.33:
		_sprite.frame = 1
	else:
		_sprite.frame = 0


func _look_at_mouse():
	var mouse = get_viewport().get_mouse_position()
	var rot = global_position.direction_to(mouse).angle() + PI / 2
	_sprite.rotation = rot
	_hitbox.rotation = rot


func _on_AnimatedSprite_animation_finished():
	match _sprite.animation:
		"swing":
			_hitbox.set_deferred("monitoring", false)
			_sprite.play("run")
			_state = State.NORMAL
			_speed = speed


func _on_HitBox_body_entered(body):
	_hitbox.set_deferred("monitoring", false)
	body.hit(_strength, _sprite.rotation)


func die():
	var world = get_viewport().get_node("Main")
	var blood = BloodScene.instance()
	blood.global_position = global_position
	world.add_child(blood)
	
	emit_signal("dead")
	queue_free()


func freeze():
	_state = State.FROZEN
	_sprite.stop()


func unfreeze():
	_sprite.playing = true
