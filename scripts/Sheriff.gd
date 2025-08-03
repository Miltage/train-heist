class_name Sheriff
extends AnimatedSprite2D

const FIRST_POSITION:int = 50
const SECOND_POSITION:int = 2800

var speed:float = 120.0
var velocity:float = 0
var dir:float = 1
var targetPos:float
var stopped:bool = false

var _timeElapsed:float

func _ready() -> void:
	targetPos = SECOND_POSITION

func _process(delta: float) -> void:
	var d:float = targetPos - position.x

	if (abs(d) > speed * 0.5):
		dir = 1.0 if (d > 0.0) else -1.0
		velocity = lerp(velocity, speed * dir, 0.2)
	else:
		velocity = lerp(velocity, 0.0, 0.2)
		if (!stopped): turn_around()
		
	position.x += velocity * delta

	if (abs(d) > 100): stopped = false

	scale.x = dir

	if (abs(velocity) > 5.0): play("running")
	else: play("default")

	_timeElapsed += delta

	position.y = 270 - abs(sin(_timeElapsed * 10)) * abs(velocity) * 0.1
	$Hands.position.y = sin(_timeElapsed * 15) * abs(velocity) * 0.035

func turn_around() -> void:
	stopped = true
	await get_tree().create_timer(2.0).timeout

	var d1:float = SECOND_POSITION - position.x
	var d2:float = FIRST_POSITION - position.x

	print(d1, " - ", d2)

	if (abs(d1) > abs(d2)): targetPos = SECOND_POSITION
	else: targetPos = FIRST_POSITION
