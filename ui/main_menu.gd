extends Control


func _on_ready():
	$MarginContainer/VBoxContainer/Start.grab_focus()


func _on_start_button_up():
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_leaderboards_button_up():
	get_tree().change_scene_to_file("res://ui/leaderboards.tscn")


func _on_exit_button_up():
	get_tree().quit()
