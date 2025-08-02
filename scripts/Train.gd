class_name Train
extends Node3D

signal player_boarded

@export var leftCircle:Path3D
@export var rightCircle:Path3D
@export var startingTrack:Path3D

var speed:float = 1.5

var _cars:Array

func _ready() -> void:
    for child in get_children():
        var car:TrainCar = child as TrainCar
        _cars.append(car)
        car.leftCircle = leftCircle
        car.rightCircle = rightCircle
        car.set_track(startingTrack)
        car.dir = 1
        car.player_boarded.connect(_on_player_boarded)

func _process(_delta: float) -> void:
    for car in _cars:
        car.speed = speed

func _on_player_boarded() -> void:
    player_boarded.emit()