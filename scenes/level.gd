extends Node2D

signal territory_invaded

const BUNKER_OFFSET: int = 60

var is_invaded: bool = false

@onready var popup_menu = $PopupMenu
@onready var result_label = $PopupMenu/Panel/MarginContainer/VBoxContainer/Result
@onready var restart_button = $PopupMenu/Panel/MarginContainer/VBoxContainer/Restart
@onready var resume_button = $PopupMenu/Panel/MarginContainer/VBoxContainer/Resume
@onready var exit_button = $PopupMenu/Panel/MarginContainer/VBoxContainer/Exit


func _on_ready():
	territory_invaded.connect(game_finished.bind(false))
	$Starship.player_dead.connect(game_finished.bind(false))
	#spawn_bunkers()


func _process(_delta):
	if $Starship:
		$HUD/MarginContainer/Score.text = "Score: " + str($Starship.player_score)
		$HUD/MarginContainer/Health.text = "Health: " + str($Starship.player_health)


func _on_player_territory_body_entered(body):
	if body is Enemy and not is_invaded:
		is_invaded = true
		territory_invaded.emit()


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


#func spawn_bunkers() -> void:
	#var start_pos_y = 600
	#var max_columns = floori(get_viewport().size.x / (Bunker.BUNKER_WIDTH + BUNKER_OFFSET))
	#var next_pos
	#var total_width = max_columns * (Bunker.BUNKER_WIDTH + BUNKER_OFFSET) - BUNKER_OFFSET
#
	#var start_pos_x = (get_viewport().size.x - total_width) / 2
	#for y in max_columns:
		#@warning_ignore("integer_division")
		#next_pos = Vector2(start_pos_x, start_pos_y)
		#var bunker = bunker_scene.instantiate()
		#bunker.position = next_pos
		#add_child(bunker)
		#start_pos_x += (Bunker.BUNKER_WIDTH + BUNKER_OFFSET)
#
