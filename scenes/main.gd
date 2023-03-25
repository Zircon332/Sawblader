extends Node2D


enum GAME_STATES {START, PLAY, END}

onready var spawner = $Spawner

var game_state = GAME_STATES.START


func _ready():
	start_game()


func start_game():
	spawner.start_spawn()


func _physics_process(delta):
	match game_state:
		GAME_STATES.START:
			pass
			
		GAME_STATES.PLAY:
			pass
			
		GAME_STATES.END:
			pass
