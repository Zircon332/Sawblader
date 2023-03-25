extends KinematicBody2D


signal bounced
signal hit(strength)

var _friction = 0.01

var rotation_speed = 2
var velocity = Vector2.ONE * 0

var _kill_streak = 0
var _frozen = false

onready var world = get_viewport().get_node("Main")
onready var _sprite = $Sawblade


func _physics_process(delta):
	if _frozen:
		return
	
	calculate_friction()
	
	_sprite.rotation_degrees += rotation_speed
	
	move_and_slide(velocity)
	bounce()
	kill_enemy()


func calculate_friction():
	velocity = lerp(velocity, Vector2.ZERO, _friction)
	rotation_speed = velocity.length() / 100


func bounce():
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			velocity = velocity.bounce(collision.normal)
			emit_signal("bounced")


func hit(strength, angle):
	velocity = Vector2.UP.rotated(angle) * strength
	_kill_streak = 0
	emit_signal("hit", strength)
	world.start_game()


func kill_enemy():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.is_in_group('enemy') and velocity.length() > 100:
			area.die(global_position.direction_to(area.global_position))
			_kill_streak += 1
			
			world.add_score(_kill_streak)


func freeze():
	_frozen = true


func unfreeze():
	_frozen = false
