extends Control


func set_time(time_elapsed):
	var minutes = time_elapsed / 60
	var seconds = int(time_elapsed) % 60
	$CenterContainer/StopwatchLabel.text = ("%02d:%02d" % [minutes, seconds])


func set_score(score):
	$Score.text = str(score)
