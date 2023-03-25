extends Path2D


const entityScene := preload("res://entities/slime/slime.tscn")

onready var context := get_parent()

onready var _timer := $Timer
onready var _rng := RandomNumberGenerator.new()
onready var _spawn_point := $SpawnPoint


func spawn_pack(pack_size:int = 4) -> void:
	for _i in range(pack_size):
		_spawn_point.unit_offset = _rng.randf()
		spawn(_offset_position(_spawn_point.global_position))


func spawn(pos: Vector2) -> void:
	var entity := entityScene.instance()
	entity.global_position = pos
	context.add_child(entity)
	entity.spawn()


func _offset_position(pos: Vector2) -> Vector2:
	var angle := _rng.randf_range(-PI, PI)
	var direction := Vector2.RIGHT.rotated(angle)
	var vector := direction * randf()
	return pos + vector


func _on_Timer_timeout():
	spawn_pack(1)


func start_spawn():
	_timer.start()	


func set_spawn_interval(interval):
	_timer.wait_time = interval
