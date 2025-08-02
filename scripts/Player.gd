class_name Player
extends CharacterBody3D

const speed:float = 3.0
const rotateSpeed:float = 0.08

var v:float = 0

func _process(_delta: float) -> void:
    if (Input.is_action_pressed("move_forward")):
        v = lerp(v, speed, 0.2)
    else:
        v *= 0.8

    if (Input.is_action_pressed("steer_left")):
        rotate_y(rotateSpeed)
    if (Input.is_action_pressed("steer_right")):
        rotate_y(-rotateSpeed)

    velocity = velocity.lerp(basis.z * v, 0.2)
    move_and_slide()