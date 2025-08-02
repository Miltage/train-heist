class_name TrainCar
extends RigidBody3D

signal player_boarded

@export var last:bool
@export var first:bool
@export var leftCircle:Path3D
@export var rightCircle:Path3D
@export var startingTrack:Path3D
@export var startingOffset:float

var _track:Path3D
var _velocity:Vector3
var _playerBehind:bool

var t:float
var dir:float
var speed:float

func _ready() -> void:
	dir = 1
	_track = startingTrack

func _physics_process(delta: float) -> void:
	t += delta * speed * dir
	if (_track):
		var trackTransform:Transform3D = _track.curve.sample_baked_with_rotation(t, true, true)
		var nextPos:Vector3 = _track.position + trackTransform.origin
		_velocity = nextPos - global_position
		move_and_collide(_velocity)
		global_basis = trackTransform.basis.rotated(Vector3.UP, PI/2 * dir)
		#print(t)
		if (t >= _track.curve.get_baked_length() || t <= 0.0):
			if (is_on_circle()): 
				t = _track.curve.get_baked_length() if (t <= 0.0) else 0.0
			else:
				set_track(get_closest_circle())

func set_track(nextTrack:Path3D) -> void:
	if (_track == nextTrack): return

	_track = nextTrack
	t = _track.curve.get_closest_offset(global_position - _track.position)
	if (!is_on_circle()):
		if (t > _track.curve.get_baked_length() * 0.5):
			dir = -1
		else:
			dir = 1
	else:
		var dz:float = global_position.z - _track.position.z
		if (dz > 0 && global_position.x < 0 || dz < 0 && global_position.x > 0): dir = 1
		elif (dz < 0 && global_position.x < 0 || dz > 0 && global_position.x > 0): dir = -1

func get_track() -> Path3D:
	return _track

func get_closest_circle() -> Path3D:
	if (global_position.x < 0):
		return leftCircle
	else:
		return rightCircle

func is_on_circle() -> bool:
	return _track == leftCircle || _track == rightCircle

func get_velocity() -> Vector3:
	return _velocity

func _on_area_3d_body_entered(body:Node3D) -> void:
	if (body is Player && last):
		_playerBehind = true
		(body as Player).followingCar = self

func _on_area_3d_body_exited(body:Node3D) -> void:
	if (body is Player):
		_playerBehind = false

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact") && _playerBehind && last):
		player_boarded.emit()