class_name Starship
extends CharacterBody2D

signal player_dead

const STARSHIP_HEIGHT: float = 8.0
const MOVEMENT_SPEED: int = 200
const ROTATION_SPEED: int = 3

var rotation_direction = 0
var player_health: int = 3
var player_score: int = 0
var reloaded: bool = true

@onready var bullet_scene = preload("res://characters/bullet/bullet.tscn")
@onready var flash_rect = $CanvasLayer/ColorRect


func _on_ready() -> void:
	SignalBus.enemy_hit.connect(add_score)


func _physics_process(delta: float) -> void:
	get_input()
	rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()


func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	velocity = transform.x * Input.get_axis("ui_down", "ui_up") * MOVEMENT_SPEED


#region Shooting
func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		fire_bullet()


func fire_bullet():
	if reloaded:
		var bullet = bullet_scene.instantiate()
		bullet.rotation = self.rotation
		bullet.position = self.global_position - Vector2(0, (STARSHIP_HEIGHT / 2))
		get_parent().add_child(bullet)
		$AudioStreamPlayer2D.play()
		reloaded = false
		$Timer.start(0.5)


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
