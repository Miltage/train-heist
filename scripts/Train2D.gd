extends Node2D

var speed:float = 2

func _process(delta: float) -> void:
    $Wheel1.rotation += delta * speed
    $Wheel2.rotation += delta * speed
    $Wheel3.rotation += delta * speed
    $Wheel4.rotation += delta * speed
    $Wheel5.rotation += delta * speed
    $Wheel6.rotation += delta * speed
    $Wheel7.rotation += delta * speed
    $Wheel8.rotation += delta * speed