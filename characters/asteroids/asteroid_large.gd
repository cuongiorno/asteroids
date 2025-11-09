extends Asteroid

@onready var asteroid_medium_scene = preload("res://characters/asteroids/asteroid_medium.tscn")
@onready var init_pos = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))


func _on_ready() -> void:
	randomize()
	sprite = $Sprite2D
	global_position = init_pos


func _on_tree_exiting():
	for i in 2:
		var asteroid_medium = asteroid_medium_scene.instantiate()
		var new_pos = self.global_position + Vector2(randf_range(-30, 30), randf_range(-30, 30))
		asteroid_medium.global_position = new_pos
		get_parent().add_child.call_deferred(asteroid_medium)
