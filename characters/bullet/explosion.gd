extends CPUParticles2D


func _on_ready():
	$AudioStreamPlayer2D.play()
	self.restart()


func _on_finished():
	queue_free()
