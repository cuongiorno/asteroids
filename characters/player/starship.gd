class_name Starship
extends CharacterBody2D

signal player_dead

var speed: int = 10
var player_health: int = 3
var player_score: int = 0
var reloaded: bool = true

@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var starship_height = $CollisionShape2D.shape.get_size()
@onready var flash_rect = $CanvasLayer/ColorRect


func _on_ready() -> void:
	SignalBus.enemy_hit.connect(add_score)


func _process(_delta) -> void:
	if Input.is_action_pressed("ui_left"):
		move_and_collide(Vector2(-speed, 0))
	if Input.is_action_pressed("ui_right"):
		move_and_collide(Vector2(speed, 0))


#region Shooting
func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		fire_bullet()


func fire_bullet():
	if reloaded:
		var bullet = bullet_scene.instantiate()
		bullet.is_friendly = true
		bullet.collision_layer = 3 
		bullet.collision_mask = 2
		bullet.position = self.global_position - Vector2(0, (starship_height.y / 2))
		get_parent().add_child(bullet)
		$AudioStreamPlayer2D.play()
		reloaded = false
		$Timer.start(1)


func _on_timer_timeout() -> void:
	reloaded = true
#endregion


func decrease_health(damage):
	flash_rect.modulate.a = 0.4
	var tween = create_tween()
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.3)
	player_health -= damage
	if player_health <= 0:
		player_dead.emit()


func add_score(points_awarded):
	player_score += points_awarded
	
