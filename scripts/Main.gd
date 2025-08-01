class_name Main
extends Node3D

@export var track:Path3D
@export var train:TrainCar

func _process(_delta: float) -> void:
	var offset = track.curve.get_closest_offset(train.position - track.position)
	$Sphere.position = track.curve.sample_baked(offset)
