class_name Player
extends CharacterBody3D

const speed:float = 3.0
const rotateSpeed:float = 0.08

var v:float = 0
var boarded:bool = false : set = set_boarded
var followingCar:TrainCar
var targetPos:Vector3
var targetRotation:Vector3

func _process(_delta: float) -> void:
	if (boarded): 
		follow_car()
		return

	if (Input.is_action_pressed("move_forward")):
		v = lerp(v, speed, 0.2)
	else:
		v *= 0.8

	if (Input.is_action_pressed("steer_left")):
		rotate_y(rotateSpeed)
	if (Input.is_action_pressed("steer_right")):
		rotate_y(-rotateSpeed)

	velocity = velocity.lerp(-basis.z * v, 0.2)
	move_and_slide()

func follow_car() -> void:
	position = followingCar.global_position + followingCar.basis.x * -1.65
	look_at(followingCar.global_position)

func set_boarded(newBoarded:bool) -> void:
	boarded = newBoarded
	$player/Bandit.visible = !boarded
	$player/Hands.visible = !boarded
