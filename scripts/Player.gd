class_name Player
extends CharacterBody3D

const speed:float = 3.0
const rotateSpeed:float = 0.08
const velThreshold:float = 0.1

var v:float = 0
var boarded:bool = false : set = set_boarded
var followingCar:TrainCar
var targetPos:Vector3
var targetRotation:Vector3

var _timeElapsed:float
var _bounce:float
var _run:float
var _anim:bool
var _gallopTime:float

func _process(delta: float) -> void:
	_timeElapsed += delta
	_run += delta

	if (_run > 0.2):
		_run = 0.0
		_anim = !_anim

	if (is_running()):
		_gallopTime += delta
		if (_gallopTime > 0.5):
			AudioManager.play_gallop()
			_gallopTime = 0.0

	$player/Hands.visible = !boarded && !Globals.holdingCoin
	$player/HandsCoin.visible = !boarded && Globals.holdingCoin
	$player/Bandit.visible = !boarded
	$player/Horse.visible = !_anim || !is_running()
	$player/Horse2.visible = _anim && is_running()

	position.y = 0.1 if _anim && is_running() else 0.0

	var s = 0.1 if (is_running()) else 0.0
	_bounce = lerp(_bounce, s, 0.2)
	scale = Vector3.ONE * 1.0 + Vector3.ONE * abs(sin(_timeElapsed * 10)) * _bounce

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

	$InteractPrompt.position = get_viewport().get_camera_3d().unproject_position(position) - ($InteractPrompt/MousePrompt.size + $InteractPrompt/InteractLabel.size) / 2
	$InteractPrompt.scale = $InteractPrompt.scale.lerp(Vector2.ONE, 0.2)

func follow_car() -> void:
	var newPos = followingCar.global_position + followingCar.basis.x * -1.65
	velocity = newPos - position
	position = newPos
	look_at(followingCar.global_position)

func set_boarded(newBoarded:bool) -> void:
	boarded = newBoarded

func is_running() -> bool:
	return velocity.length() > velThreshold || boarded

func _ready() -> void:
	Globals.show_world_interaction.connect(_on_interaction_shown)
	Globals.hide_world_interaction.connect(_on_interaction_hidden)
	$InteractPrompt.hide()

func _on_interaction_shown(prompt:String) -> void:
	if (boarded): return
	$InteractPrompt/InteractLabel.text = prompt
	$InteractPrompt.show()
	await get_tree().process_frame
	$InteractPrompt.pivot_offset = ($InteractPrompt/MousePrompt.size + $InteractPrompt/InteractLabel.size)/2
	$InteractPrompt.scale = Vector2.ONE * 1.4

func _on_interaction_hidden() -> void:
	$InteractPrompt.hide()