class_name Bandit
extends CharacterBody2D

var speed:float = 100
var dir:float = 1
var overlappingLadder:bool = false
var onLadder:bool = false

var _timeElapsed:float
var _targetVelocity:Vector2

func get_input():
	if (!visible): 
		velocity = Vector2.ZERO
		_targetVelocity = Vector2.ZERO
		return

	var input_dir = Input.get_axis("steer_left", "steer_right")
	var climb_dir = Input.get_axis("move_forward", "move_backward")
	_targetVelocity = Vector2(input_dir * speed, velocity.y)
	velocity = velocity.lerp(_targetVelocity, 0.4)

	if (Input.is_action_just_pressed("move_forward")):
		if (overlappingLadder): onLadder = true
		else: jump()

	if (Input.is_action_just_pressed("jump") && !onLadder):
		jump()
	elif (Input.is_action_just_pressed("jump") && onLadder):
		onLadder = false

	if (velocity.x < 0): dir = -1
	elif (velocity.x > 0): dir = 1

	if (input_dir != 0 || climb_dir != 0): $Sprite2D.play("running")
	else: $Sprite2D.play("default")

	if (onLadder):
		if (Input.is_action_pressed("move_forward")):
			velocity.y = -100
		elif (Input.is_action_pressed("move_backward")):
			velocity.y = 100
		else: 
			velocity.y = 0

func _physics_process(delta) -> void:
	if (!overlappingLadder): onLadder = false
	_timeElapsed += delta

	get_input()
	if (!onLadder): velocity.y += 10
	move_and_slide()
	$Sprite2D.flip_h = dir < 0
	$EmptyHands.flip_h = dir < 0
	$CoinHands.flip_h = dir < 0

	$EmptyHands.visible = !Globals.holdingCoin
	$CoinHands.visible = Globals.holdingCoin

	if (is_on_floor()):
		$Sprite2D.position.y = -80 - abs(sin(_timeElapsed * 10)) * abs(velocity.x) * 0.1
		$EmptyHands.position.y = $Sprite2D.position.y + sin(_timeElapsed * 15) * abs(velocity.x) * 0.035
		$CoinHands.position.y = $Sprite2D.position.y - sin(_timeElapsed * 15) * abs(velocity.x) * 0.035
	elif (!onLadder):
		$Sprite2D.play("jumping")

	scale = scale.lerp(Vector2.ONE, 0.4)

func jump() -> void:
	velocity.y = -220
	scale = Vector2.ONE * 1.15

func pop() -> void:
	scale = Vector2.ONE * 1.25

func _ready() -> void:
	visibility_changed.connect(pop)
