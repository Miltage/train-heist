class_name Chest
extends Node2D

signal bandit_entered
signal bandit_exited

enum ChestState {
	OPEN,
	OPEN_COIN,
	CLOSED,
	LOCKED,
	HIDING
}

var containsCoins:bool = false
var banditOverlapping:bool = false
var locked:bool = false
var state:ChestState = ChestState.CLOSED : set = set_state

func _on_body_entered(body:Node2D) -> void:
	if (body is Bandit): banditOverlapping = true

func _on_body_exited(body:Node2D) -> void:
	if (body is Bandit): banditOverlapping = false

func on_primary_interact() -> void:
	if (state == ChestState.CLOSED):
		state = ChestState.OPEN_COIN if containsCoins else ChestState.OPEN
	elif (state == ChestState.OPEN):
		state = ChestState.HIDING
		bandit_entered.emit()
	elif (state == ChestState.HIDING):
		state = ChestState.OPEN
		bandit_exited.emit()
	elif (state == ChestState.OPEN_COIN):
		Globals.holdingCoin = true
		state = ChestState.OPEN

func on_secondary_interact() -> void:
	if (state == ChestState.OPEN):
		state = ChestState.HIDING
		bandit_entered.emit()
	elif (state == ChestState.HIDING):
		state = ChestState.OPEN
		bandit_exited.emit()

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact") && banditOverlapping):
		on_primary_interact()
	# elif (Input.is_action_just_pressed("interact2") && banditOverlapping):
	# 	on_secondary_interact()

func set_state(newState:ChestState) -> void:
	state = newState

	$Closed.hide()
	$Open.hide()
	$OpenCoin.hide()
	$Hidden.hide()
	$Locked.hide()

	if (state == ChestState.CLOSED): $Closed.show()
	elif (state == ChestState.OPEN): $Open.show()
	elif (state == ChestState.HIDING): $Hidden.show()
	elif (state == ChestState.LOCKED): $Locked.show()
	elif (state == ChestState.OPEN_COIN): $OpenCoin.show()
	scale = Vector2.ONE * 1.2

func _process(_delta: float) -> void:
	scale = scale.lerp(Vector2.ONE, 0.4)

func close(withCoin:bool) -> void:
	state = ChestState.CLOSED
	containsCoins = withCoin