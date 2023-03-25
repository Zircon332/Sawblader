extends KinematicBody2D


var _friction = 0.01

var rotation_speed = 2
var velocity = Vector2.ONE * 0

onready var _sprite = $Sawblade


func _physics_process(delta):
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


func hit(strength, angle):
	velocity = Vector2.UP.rotated(angle) * strength * 10


func kill_enemy():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.is_in_group('enemy'):
			var dir = velocity.normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT.rotated(rand_range(0, TAU))
				
			area.die(dir)
