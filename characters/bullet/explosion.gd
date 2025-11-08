extends CPUParticles2D


func _on_ready():
	#$AudioStreamPlayer2D.play()
	AudioManager.play_sound("res://characters/bullet/pixel-explosion-319166.mp3")
	self.restart()


func _on_finished():
	queue_free()
