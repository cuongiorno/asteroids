extends Node2D

@onready var popup_menu = $PopupMenu
@onready var result_label = $PopupMenu/Panel/MarginContainer/VBoxContainer/Result
@onready var resume_button = $PopupMenu/Panel/MarginContainer/VBoxContainer/Resume
@onready var exit_button = $PopupMenu/Panel/MarginContainer/VBoxContainer/Exit
@onready var asteroid_large_scene = preload("res://characters/asteroids/asteroid_large.tscn")


func _on_ready():
	$Starship.player_dead.connect(game_finished.bind(false))
	spawn_asteroids()


func _process(_delta):
	if $Starship:
		$HUD/MarginContainer/Score.text = "Score: " + str($Starship.player_score)
		$HUD/MarginContainer/Health.text = "Health: " + str($Starship.player_health)


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			pause_game()
			get_viewport().set_input_as_handled()


func pause_game():
	result_label.text = "Pause"
	get_tree().paused = true
	popup_menu.visible = true


func game_finished(victory: bool) -> void:
	$Starship.visible = false
	$Starship.set_physics_process(false)
	$Starship.set_process(false)
	await get_tree().create_timer(2.0).timeout
	
	var message: String
	if victory:
		message = "You won! Your final score: "
	else:
		message = "Game over! Your final score: "
	Global.update_leaderboards({
		"Timestamp": Time.get_datetime_string_from_system(), 
		"Score": str($Starship.player_score)})
	result_label.text = message + str($Starship.player_score)
	get_tree().paused = true
	resume_button.visible = false
	popup_menu.visible = true
	exit_button.grab_focus()


func spawn_asteroids() -> void:
	for i in 5:
		var asteroid_large = asteroid_large_scene.instantiate()
		$EnemySpawner.add_child(asteroid_large)
