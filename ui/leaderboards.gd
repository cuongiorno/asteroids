extends Control

@onready var grid = $MarginContainer/VBoxContainer/GridContainer


func _on_ready():
	load_results_to_grid()


func _on_exit_button_up():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func load_results_to_grid():
	for row in Global.leaderboards:
		var timestamp = Label.new()
		timestamp.text = row["Timestamp"]
		timestamp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.add_child(timestamp)
		var score = Label.new()
		score.text = row["Score"]
		score.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		score.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.add_child(score)
