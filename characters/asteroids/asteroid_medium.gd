extends Asteroid

@onready var asteroid_small_scene = preload("res://characters/asteroids/asteroid_small.tscn")


func _on_ready() -> void:
	randomize()
	awarded_points = 2
	sprite = $Sprite2D


func _on_tree_exiting():
	for i in 2:
		var asteroid_small = asteroid_small_scene.instantiate()
		var new_pos = self.global_position + Vector2(randf_range(-30, 30), randf_range(-30, 30))
		asteroid_small.global_position = new_pos
		get_parent().add_child.call_deferred(asteroid_small)
