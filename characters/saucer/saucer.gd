class_name Saucer
extends RigidBody2D

var player
var turn_speed = 5.0
var move_speed = 50.0
var direction: Vector2

@onready var screensize = get_viewport_rect().size
@onready var init_pos = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
@onready var bullet_scene = preload("res://characters/bullet/bullet.tscn")


func _ready():
	randomize()
	global_position = init_pos
	player = get_tree().get_first_node_in_group("player")
	if player:
		direction = (player.global_position - global_position).normalized()
	pick_new_direction()


func _physics_process(delta):
	if not player:
		return
	direction = (player.global_position - global_position).normalized()
	var desired_angle = direction.angle()
	rotation = lerp_angle(rotation, desired_angle, turn_speed * delta)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var xform = state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	state.transform = xform


func _on_reorient_timeout():
	pick_new_direction()


func _on_shoot_timeout():
	var bullet = bullet_scene.instantiate()
	var random_rotation_deviation = randf_range(-PI / 8, PI / 8)
	bullet.rotation = self.direction.angle() + (PI / 2) + random_rotation_deviation
	bullet.collision_layer = 8 
	bullet.collision_mask = 8
	bullet.position = self.global_position 
	get_parent().add_child(bullet)
	$Shoot.start(3.0)


func pick_new_direction():
	if not player:
		return
	constant_force = direction * move_speed


func _on_tree_exiting():
	SignalBus.saucer_died.emit()
