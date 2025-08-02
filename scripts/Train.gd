class_name Train
extends Node3D

@export var leftCircle:Path3D
@export var rightCircle:Path3D
@export var startingTrack:Path3D

var speed:float = 2

var _cars:Array

func _ready() -> void:
    for child in get_children():
        var car:TrainCar = child as TrainCar
        _cars.append(car)
        car.leftCircle = leftCircle
        car.rightCircle = rightCircle
        car.set_track(startingTrack)
        car.dir = 1

func _process(_delta: float) -> void:
    for car in _cars:
        car.speed = speed