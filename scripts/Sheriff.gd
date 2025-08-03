class_name Sheriff
extends AnimatedSprite2D

const FIRST_POSITION:int = 50
const SECOND_POSITION:int = 2800
const PATROL_SPEED:int = 120
const AGGRO_SPEED:int = 180

@export var bandit:Bandit

var speed:float = 0
var velocity:float = 0
var dir:float = 1
var targetPos:float
var stopped:bool = false
var aggro:bool = false

var _lastAggro:bool = false
var _timeElapsed:float

func _ready() -> void:
	targetPos = SECOND_POSITION

func _process(delta: float) -> void:
	speed = AGGRO_SPEED if aggro else PATROL_SPEED

	if (aggro): targetPos = bandit.position.x

	var d:float = targetPos - position.x

	if (abs(d) > speed * 0.5 && !stopped):
		dir = 1.0 if (d > 0.0) else -1.0
		velocity = lerp(velocity, speed * dir, 0.2)
	else:
		velocity = lerp(velocity, 0.0, 0.2)
		if (aggro): catch_bandit()
		if (!stopped): turn_around()
		
	position.x += velocity * delta

	if (abs(d) > 100): stopped = false

	if (abs(velocity) > 5.0): play("running")
	else: play("default")

	_timeElapsed += delta

	position.y = 270 - abs(sin(_timeElapsed * 10)) * abs(velocity) * 0.1
	$Hands.position.y = sin(_timeElapsed * 15) * abs(velocity) * 0.035
	$HandsGun.position.y = $Hands.position.y

	$Hands.visible = !aggro
	$HandsGun.visible = aggro

	flip_h = dir < 0
	$Hands.flip_h = flip_h
	$HandsGun.flip_h = flip_h

	if (abs(position.x - bandit.position.x) < 500 && abs(position.y - bandit.position.y) < 100 && bandit.visible): 
		aggro = true
		if (_lastAggro != aggro): pop()
	elif (aggro && abs(position.x - bandit.position.x) > 600):
		aggro = false
		if (_lastAggro != aggro): pop()
		turn_around()

	scale = scale.lerp(Vector2.ONE, 0.4)
	_lastAggro = aggro

func turn_around() -> void:
	stopped = true
	await get_tree().create_timer(2.0).timeout
	
	aggro = false
	var d1:float = SECOND_POSITION - position.x
	var d2:float = FIRST_POSITION - position.x

	if (abs(d1) > abs(d2)): targetPos = SECOND_POSITION
	else: targetPos = FIRST_POSITION

func catch_bandit() -> void:
	var dy:float = bandit.position.y - position.y
	if (abs(dy) < 100):
		bandit.show()
		Globals.game_ended.emit(Globals.GameEndReason.CAUGHT_BY_SHERIFF)

func pop() -> void:
	scale = Vector2.ONE * 1.25
