extends KinematicBody2D


var _friction = 0.01

var rotation_speed = 2
var velocity = Vector2.ONE * 1000

onready var _sprite = $Sawblade


func _physics_process(delta):
	calculate_friction()
	
	_sprite.rotation_degrees += rotation_speed
	
	move_and_slide(velocity)
	bounce()
	


func calculate_friction():
	velocity = lerp(velocity, Vector2.ZERO, _friction)
	rotation_speed = velocity.length() / 100


func bounce():
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			velocity = velocity.bounce(collision.normal)
