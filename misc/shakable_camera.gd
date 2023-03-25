extends Camera2D
class_name ShakableCamera


export(float) var shake_decay = 0.1

var _strength = 0


func _process(delta):
	offset = Vector2.RIGHT.rotated(rand_range(0, TAU)).normalized() * _strength
	_strength = lerp(_strength, 0, shake_decay)


func shake(strength):
	_strength += strength
