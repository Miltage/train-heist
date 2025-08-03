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
	if (body is Bandit): 
		banditOverlapping = true
		_show_interaction_prompt()

func _on_body_exited(body:Node2D) -> void:
	if (body is Bandit): 
		banditOverlapping = false
		Globals.hide_train_interaction.emit()

func on_primary_interact() -> void:
	if (state == ChestState.CLOSED):
		state = ChestState.OPEN_COIN if containsCoins else ChestState.OPEN
		AudioManager.play_chest_open()
	elif (state == ChestState.OPEN):
		state = ChestState.HIDING
		bandit_entered.emit()
		AudioManager.play_chest_close()
	elif (state == ChestState.HIDING):
		state = ChestState.OPEN
		bandit_exited.emit()
		AudioManager.play_chest_open()
	elif (state == ChestState.OPEN_COIN):
		Globals.holdingCoin = true
		state = ChestState.OPEN
		AudioManager.play_grab_coin()

func on_secondary_interact() -> void:
	if (state == ChestState.OPEN):
		state = ChestState.HIDING
		bandit_entered.emit()
	elif (state == ChestState.HIDING):
		state = ChestState.OPEN
		bandit_exited.emit()

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

	if (banditOverlapping): _show_interaction_prompt()

func _process(_delta: float) -> void:
	scale = scale.lerp(Vector2.ONE, 0.4)

	if (Input.is_action_just_pressed("interact") && banditOverlapping):
		on_primary_interact()

func close(withCoin:bool) -> void:
	if (state == ChestState.HIDING): return
	state = ChestState.CLOSED
	containsCoins = withCoin

func open() -> void:
	state = ChestState.OPEN

func _on_game_ended(reason:Globals.GameEndReason) -> void:
	if ((reason == Globals.GameEndReason.CAUGHT_BY_SHERIFF || reason == Globals.GameEndReason.FOUND_ON_BOARD) && state == ChestState.HIDING):
		AudioManager.play_chest_open()
		open()

func _ready() -> void:
	Globals.game_ended.connect(_on_game_ended)

func _show_interaction_prompt() -> void:
	if (state == ChestState.CLOSED):
		Globals.show_train_interaction.emit("open chest")
	elif (state == ChestState.OPEN):
		Globals.show_train_interaction.emit("hide in chest")
	elif (state == ChestState.HIDING):
		Globals.show_train_interaction.emit("leave chest")
	elif (state == ChestState.OPEN_COIN):
		Globals.show_train_interaction.emit("grab coin")