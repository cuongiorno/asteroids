extends Enemy


func _on_ready() -> void:
	awarded_points = 100


func _on_move_timer_timeout():
	self.global_position.x += 10
	if self.global_position.x > get_viewport_rect().size.x:
		queue_free()
