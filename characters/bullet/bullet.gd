class_name Bullet
extends RigidBody2D

const SPEED: int = 1000

@onready var explosion = preload("res://characters/bullet/explosion.tscn").instantiate()
@onready var velocity = Vector2(0, -SPEED).rotated(rotation)
@onready var viewport_size: Vector2 = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	var collision_info
	collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		var thing_we_hit = collision_info.get_collider()
		spawn_explosion()
		if thing_we_hit.is_in_group("enemies"):
			SignalBus.enemy_hit.emit(thing_we_hit.awarded_points)
			thing_we_hit.queue_free()
			queue_free()
		if thing_we_hit is Saucer:
			thing_we_hit.damage_at(self.global_position)
			queue_free()
	if (position.y < 0) or (position.x < 0) or (position.y > viewport_size.y) or (position.x > viewport_size.x):
		queue_free()


func spawn_explosion():
	explosion.global_position = self.global_position
	get_tree().root.add_child(explosion)
