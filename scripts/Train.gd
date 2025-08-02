class_name Train
extends Node3D

signal player_boarded
signal train_stopped

@export var leftCircle:Path3D
@export var rightCircle:Path3D
@export var startingTrack:Path3D

var speed:float = 0
var targetSpeed:float = 0

var _baseSpeed:float = 1.4
var _stopped:bool
var _cars:Array

func _ready() -> void:
	targetSpeed = _baseSpeed

	for child in get_children():
		if (child is TrainCar):
			var car:TrainCar = child as TrainCar
			_cars.append(car)
			car.leftCircle = leftCircle
			car.rightCircle = rightCircle
			car.set_track(startingTrack)
			car.dir = 1
			car.player_boarded.connect(_on_player_boarded)

func _process(_delta: float) -> void:
	speed = move_toward(speed, targetSpeed, 0.05)

	if (speed <= 0.01 && targetSpeed == 0):
		if (!_stopped):
			train_stopped.emit()
			_stopped = true
	else:
		_stopped = false

	for car in _cars:
		car.speed = speed

func _on_player_boarded() -> void:
	player_boarded.emit()

func stop() -> void:
	await get_tree().create_timer(max(0, 4 - speed)).timeout
	targetSpeed = 0
	$StopWait.start()

func _on_stop_wait_timeout() -> void:
	_baseSpeed += 0.05
	targetSpeed = min(_baseSpeed, 4)

func get_pos() -> Vector3:
	return _cars[0].position