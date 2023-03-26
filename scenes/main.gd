extends Node2D


enum GAME_STATES {START, PLAY, END}

onready var spawner = $Spawner
onready var _camera = $ShakableCamera
onready var _freeze_timer = $FreezeTimer
onready var _player = $Player
onready var _audio_metal = $AudioStreamPlayer2D
onready var _audio_freeze = $AudioStreamPlayer2D2
onready var _audio_splat = $AudioStreamPlayer2D3
onready var _audio_bounce = $AudioStreamPlayer2D4

var game_state = GAME_STATES.START
var time_elapsed = 0
var score = 0

var _frozen = false


func _ready():
	$UI/StartScreen.visible = true
	$UI/HUD.visible = false


func start_game():
	if game_state != GAME_STATES.PLAY:
		game_state = GAME_STATES.PLAY
		spawner.start_spawn()
		$UI/StartScreen.visible = false
		$UI/HUD.visible = true


func _process(delta):
	if _frozen:
		_camera.shake(0.4)


func _physics_process(delta):
	match game_state:
		GAME_STATES.START:
			pass
			
		GAME_STATES.PLAY:
			time_elapsed += delta
			$UI/HUD.set_time(time_elapsed)
			spawner.set_pack_size(time_elapsed / 2)
			var player = $Player
			$UI/HUD/Strength/Text.text = str(int(player._strength))
			
		GAME_STATES.END:
			if Input.is_action_just_pressed("swing"):
				var game_scene = load("res://scenes/main.tscn")
				get_tree().change_scene_to(game_scene)


func add_score(points):
	score += points
	$UI/HUD.set_score(score)


func _on_Player_dead():
	_camera.shake(50)
	game_state = GAME_STATES.END
	$UI/EndScreen.visible = true
	$Saw.queue_free()
	_audio_splat.play()


func _on_Saw_bounced():
	_camera.shake(5)
	_audio_bounce.play()


func _on_Spawner_spawned(entity):
	entity.connect("dead", self, "_on_Slime_dead")


func _on_Slime_dead():
	_camera.shake(3)
	_audio_splat.play()


func _on_Saw_hit(strength):
	_camera.shake(min(float(strength) / 100, 100))
	_audio_metal.play()
	
	if strength < _player.max_strength * 0.67:
		return
	
	_freeze_timer.wait_time = lerp(0, 1, float(strength) / _player.max_strength)
	var entities = get_tree().get_nodes_in_group("entities")
	
	for ent in entities:
		ent.freeze()
		
	spawner.stop_spawn()
	
	_freeze_timer.start()
	_frozen = true
	
	_audio_freeze.play()


func _on_FreezeTimer_timeout():
	var entities = get_tree().get_nodes_in_group("entities")
	
	for ent in entities:
		ent.unfreeze()
	
	spawner.start_spawn()
	_frozen = false
