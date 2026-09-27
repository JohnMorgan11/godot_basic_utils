## Rotation Component -- Used to add rotation to a Node3D. Can be used to create continous rotation or set a randomized amount of rotation only on ready. 

extends Node

enum RotationAxis {X, Y, Z}

@export var Target : Node3D = null ## The Node to be rotated 
@export var Axis : RotationAxis = RotationAxis.Y ## The axis of rotation, X, Y, or Z 
@export var Speed : float = 0.0 ## The rotational speed -- negative values rotate in the opposite direction. Leaving this at zero and setting the Starting Range will rotate the target randomly exactly once.
@export var StartingRange : Vector2 = Vector2.ZERO ## Adds a random amount of rotation ranging from X to Y on ready

var _original_speed : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_original_speed = Speed
	
	if StartingRange == Vector2.ZERO:
		return
	if !Target:
		return 
	
	var initial_rotation : float = deg_to_rad(randf_range(StartingRange.x, StartingRange.y))
	
	match Axis:
		RotationAxis.X:
			Target.rotate_x(initial_rotation)
		RotationAxis.Y:
			Target.rotate_y(initial_rotation)
		RotationAxis.Z:
			Target.rotate_z(initial_rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Speed == 0.0:
		return 
	if !Target:
		return
	
	var rotation_speed : float = Speed * delta 
	
	match Axis:
		RotationAxis.X:
			Target.rotation.x += rotation_speed
		RotationAxis.Y:
			Target.rotation.y += rotation_speed
		RotationAxis.Z:
			Target.rotation.z += rotation_speed


func stop() -> void:
	Speed = 0.0


func reset() -> void:
	Speed = _original_speed


func change_speed(new_speed : float) -> void:
	Speed = new_speed


func reverse() -> void:
	Speed *= -1.0
