extends Area2D


const BloodParticles = preload("res://particles/blood.tscn")

export(int) var speed := 100
export(float) var spread := 30

var direction := Vector2.UP
var size := 3


func _ready():
	rotation = rand_range(0, TAU)


func _physics_process(delta) -> void:
	position += delta * speed * direction


func spawn() -> void:
	var center_offset := 50
	var target := Vector2(
		rand_range(center_offset, get_viewport_rect().size.x - center_offset),
		rand_range(center_offset, get_viewport_rect().size.y - center_offset)
	)
	
	direction = position.direction_to(target)


func _on_VisibilityNotifier2D_screen_exited():
	pass


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func die(dir):
	var world = get_viewport().get_node("Main")
	var blood = BloodParticles.instance()
	blood.global_position = global_position
	blood.rotation = dir.angle()
	world.add_child(blood)
	queue_free()


func _on_Slime_body_entered(body):
	if body.has_method("die"):
		body.die()
