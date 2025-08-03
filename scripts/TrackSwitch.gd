class_name TrackSwitch
extends Area3D

@export var track1:Path3D
@export var track2:Path3D
@export var flag:bool : set = set_flag
@export var dir:float = 1

var _canPlayerSwitch:bool

func _ready() -> void:
	flag = false

func _on_body_entered(body:Node3D) -> void:
	if (body is TrainCar):
		var trainCar:TrainCar = body as TrainCar
		if (dir < 0 && trainCar.get_velocity().x > 0): return
		if (dir > 0 && trainCar.get_velocity().x < 0): return
		if (flag): switch_car_to_track(body, track1)
		else: switch_car_to_track(body, track2)
		if (trainCar.last): switch_tracks()
	elif (body is Player):
		_canPlayerSwitch = true

func switch_car_to_track(car:TrainCar, track:Path3D) -> void:
	car.set_track(track)

func set_flag(newFlag:bool) -> void:
	flag = newFlag
	$arrow1.visible = !flag
	$arrow2.visible = flag

func _on_body_exited(body: Node3D) -> void:
	if (body is Player):
		_canPlayerSwitch = false

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("interact") && _canPlayerSwitch):
		switch_tracks()

func switch_tracks() -> void:
	flag = !flag
