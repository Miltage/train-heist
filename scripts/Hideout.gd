class_name Hideout
extends Area3D

var playerOverlapping:bool = false
var _timeElapsed:float

func _on_body_entered(body:Node3D) -> void:
	if (body is Player):
		playerOverlapping = true

func _on_body_exited(body:Node3D) -> void:
	if (body is Player):
		playerOverlapping = false

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact") && playerOverlapping):
		Globals.holdingCoin = false
		Globals.coinsCollected += 1
		Globals.coin_collected.emit()

func _process(delta: float) -> void:
	_timeElapsed += delta
	$arrow.position.z = 2.0 + abs(sin(_timeElapsed * 5)) * 0.25
	$arrow.visible = Globals.holdingCoin