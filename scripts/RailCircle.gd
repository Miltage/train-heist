class_name RailCircle
extends Path3D

func _init() -> void:
    curve = Curve3D.new()

    var numPoints:int = 64
    var dist:float = 6.75
    for i in numPoints:
        var angle:float = (i * PI * 2) / numPoints
        curve.add_point(Vector3(cos(angle) * dist, 0, sin(angle) * dist))

    curve.set_closed(true)
