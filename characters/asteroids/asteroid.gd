class_name Asteroid
extends RigidBody2D

var awarded_points
var sprite
var angle = 0.0

@onready var direction = Vector2(randf_range(-50, 50), randf_range(-50, 50))
@onready var screensize = get_viewport_rect().size


func _physics_process(_delta):
	# constant rotation
	angle = wrapf(angle + 0.03, -PI, PI)
	sprite.rotation = angle
	
	constant_force = direction


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# wrap around the edges
	var xform = state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	state.transform = xform
