extends Node2D


enum GAME_STATES {START, PLAY, END}

onready var spawner = $Spawner

var game_state = GAME_STATES.START
var time_elapsed = 60
var score = 0


func _ready():
	start_game()


func start_game():
	game_state = GAME_STATES.PLAY
	spawner.start_spawn()


func _physics_process(delta):
	match game_state:
		GAME_STATES.START:
			pass
			
		GAME_STATES.PLAY:
			time_elapsed += delta
			$UI/HUD.set_time(time_elapsed)
			spawner.set_pack_size(time_elapsed / 2)
			
			
		GAME_STATES.END:
			pass


func add_score(points):
	score += points
	$UI/HUD.set_score(score)
