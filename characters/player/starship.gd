class_name Starship
extends RigidBody2D

signal player_dead

const STARSHIP_HEIGHT: float = 8.0

@export var engine_power = 400
@export var spin_power = 500

var thrust = Vector2.ZERO
var rotation_dir = 0
var teleport_pos = null
var player_health: int = 3
var player_score: int = 0
var reloaded: bool = true
var immune: bool = false

@onready var bullet_scene = preload("res://characters/bullet/bullet.tscn")
@onready var flash_rect = $CanvasLayer/ColorRect
@onready var screensize = get_viewport_rect().size


func _on_ready() -> void:
	SignalBus.enemy_hit.connect(add_score)
	global_position = screensize / 2


#region Movement
func _physics_process(_delta: float) -> void:
	get_input()
	constant_force = thrust 
	constant_torque = rotation_dir * spin_power 


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var xform = state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	state.transform = xform

	if teleport_pos:
		state.transform.origin = teleport_pos
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		teleport_pos = null


func get_input():
	thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		thrust = -transform.y * engine_power
	if Input.is_action_just_pressed("warp"):
		teleport_pos = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
#endregion


#region Shooting
func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		fire_bullet()


func _on_timer_timeout() -> void:
	reloaded = true


func fire_bullet():
	if reloaded:
		var bullet = bullet_scene.instantiate()
		bullet.rotation = self.rotation
		bullet.position = self.global_position - Vector2(0, (STARSHIP_HEIGHT / 2))
		get_parent().add_child(bullet)
		#$AudioStreamPlayer2D.play()
		reloaded = false
		$Timer.start(0.25)
#endregion


#region Damage taken
func decrease_health(damage):
	flash_rect.modulate.a = 0.4
	var tween = create_tween()
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.3)
	player_health -= damage
	if player_health <= 0:
		player_dead.emit()


func _on_body_entered(body):
	if not immune:
		if (body is Asteroid) and (player_health > 0):
			decrease_health(1)
			teleport_pos = screensize / 2
			immune = true
			$AnimationPlayer.play("blink")
			await get_tree().create_timer(3.0).timeout
			immune = false
#endregion


func add_score(points_awarded):
	player_score += points_awarded
