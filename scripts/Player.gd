class_name Player
extends RigidBody3D

const speed:float = 0.075
const rotateSpeed:float = 0.08

var velocity:float = 0

func _process(_delta: float) -> void:
    if (Input.is_action_pressed("move_forward")):
        velocity = lerp(velocity, speed, 0.2)
    else:
        velocity *= 0.8

    if (Input.is_action_pressed("steer_left")):
        rotate_y(rotateSpeed)
    if (Input.is_action_pressed("steer_right")):
        rotate_y(-rotateSpeed)

    move_and_collide(basis.z * velocity)