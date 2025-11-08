extends Node

var audio_player = AudioStreamPlayer.new()


func _ready() -> void:
	add_child(audio_player)


func play_sound(sound_file_path):
	audio_player.stream = load(sound_file_path)
	audio_player.play()
