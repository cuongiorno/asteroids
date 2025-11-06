extends RigidBody2D

#const ROTATION_SPEED: int = 3
#const ACCELERATION_SPEED: int = 400
#const DECELERATION_SPEED: int = 100

@export var engine_power = 400
@export var spin_power = 1000

var thrust = Vector2.ZERO
var rotation_dir = 0

@onready var screensize = get_viewport_rect().size
#func _process(delta: float) -> void:
	#rotation_direction = Input.get_axis("ui_left", "ui_right")
	#rotation += rotation_direction * ROTATION_SPEED * delta
#
	#if Input.is_action_pressed("ui_up"):
		#thrust_speed = move_toward(thrust_speed, 200, ACCELERATION_SPEED * delta)
	#else:
		#thrust_speed = move_toward(thrust_speed, 0, DECELERATION_SPEED * delta)
		#

func _physics_process(_delta: float) -> void:
	get_input()
	constant_force = thrust 
	constant_torque = rotation_dir * spin_power 


func get_input():
	thrust = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		thrust = -transform.y * engine_power
	rotation_dir = Input.get_axis("ui_left", "ui_right")


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var xform = state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	state.transform = xform
