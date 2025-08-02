class_name TrackSwitch
extends Area3D

@export var track1:Path3D
@export var track2:Path3D
@export var flag:bool
@export var dir:float = 1

func _on_body_entered(body:Node3D) -> void:
    if (body is TrainCar):
        var trainCar:TrainCar = body as TrainCar
        if (dir < 0 && trainCar.get_velocity().x > 0): return
        if (dir > 0 && trainCar.get_velocity().x < 0): return
        if (flag): switch_car_to_track(body, track1)
        else: switch_car_to_track(body, track2)
        if (trainCar.last): flag = !flag

func switch_car_to_track(car:TrainCar, track:Path3D) -> void:
    car.set_track(track)