extends Particles2D


func _ready():
	get_tree().create_timer(1).connect("timeout", self, "_on_Timer_timeout")
	emitting = true


func _on_Timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.transparent, 2)
	tween.tween_callback(self, "queue_free")
