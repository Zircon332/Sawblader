extends Node2D


enum GAME_STATES {START, PLAY, END}

onready var spawner = $Spawner

var game_state = GAME_STATES.START
var time_elapsed = 0
var score = 0


func start_game():
	if game_state != GAME_STATES.PLAY:
		game_state = GAME_STATES.PLAY
		spawner.start_spawn()
		$UI/StartScreen.visible = false


func _physics_process(delta):
	match game_state:
		GAME_STATES.START:
			pass
			
		GAME_STATES.PLAY:
			time_elapsed += delta
			$UI/HUD.set_time(time_elapsed)
			spawner.set_pack_size(time_elapsed / 2)
			
		GAME_STATES.END:
			if Input.is_action_just_pressed("swing"):
				var game_scene = load("res://scenes/main.tscn")
				get_tree().change_scene_to(game_scene)


func add_score(points):
	score += points
	$UI/HUD.set_score(score)


func _on_Player_dead():
	game_state = GAME_STATES.END
	$UI/EndScreen.visible = true
