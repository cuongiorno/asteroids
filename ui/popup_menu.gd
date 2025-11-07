extends CanvasLayer


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		resume_game()
		get_viewport().set_input_as_handled()


func _on_resume_button_up():
	resume_game()


func _on_restart_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_exit_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_visibility_changed():
	if visible:
		$Panel/MarginContainer/VBoxContainer/Resume.grab_focus()


func resume_game():
	get_tree().paused = false
	hide()
