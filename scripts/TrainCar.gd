class_name TrainCar
extends Node3D

@export var leftCircle:Path3D
@export var rightCircle:Path3D

@export var circleTrack:Path3D
@export var track:Path3D

var t:float

func _process(delta: float) -> void:
    t += delta * 4
    if (track):
        var trackTransform:Transform3D = track.curve.sample_baked_with_rotation(t, true, true)
        position = track.position + trackTransform.origin
        basis = trackTransform.basis.rotated(Vector3.UP, PI/2)
        prints(t, track.curve.get_baked_length())
        if (t >= track.curve.get_baked_length()):
            switch_track(get_closest_circle())

func switch_track(nextTrack:Path3D) -> void:
    if (nextTrack == track):
        t = 0
    else:
        track = nextTrack
        t = track.curve.get_closest_offset(position - track.position)

func get_closest_circle() -> Path3D:
    if (position.distance_squared_to(leftCircle.position) < position.distance_squared_to(rightCircle.position)):
        return leftCircle
    else:
        return rightCircle