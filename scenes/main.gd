extends Node2D


enum GAME_STATES {START, PLAY, END}

onready var spawner = $Spawner

var game_state = GAME_STATES.START
var time_elapsed = 0


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
			
		GAME_STATES.END:
			pass


func _process(delta):
	$UI/HUD.set_time(time_elapsed)
