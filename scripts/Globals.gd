extends Node

enum GameEndReason {
	COLLECTED_ALL_COINS,
	FOUND_ON_BOARD,
	CAUGHT_BY_SHERIFF,
	KILLED_IN_TUNNEL
}

enum GameState {
	RUNNING,
	OVER
}

signal game_ended(reason:GameEndReason)
signal game_restarted
signal coin_collected
signal show_world_interaction(prompt:String)
signal hide_world_interaction()
signal show_train_interaction(prompt:String)
signal hide_train_interaction()
signal bandit_roof_position_changed(index:int)

const COINS_TO_WIN:int = 3

var holdingCoin:bool = false
var coinsCollected:int = 0
var state:GameState

func _init() -> void:
	game_ended.connect(_on_game_ended)
	game_restarted.connect(_on_game_restarted)
	coin_collected.connect(_on_coin_collected)
	show_world_interaction.connect(_on_world_interaction_shown)
	hide_world_interaction.connect(_on_world_interaction_hidden)
	show_train_interaction.connect(_on_train_interaction_shown)
	hide_train_interaction.connect(_on_train_interaction_hidden)
	bandit_roof_position_changed.connect(_on_bandit_roof_position_changed)

func _on_game_ended(_reason:GameEndReason) -> void:
	state = GameState.OVER
	get_tree().paused = true

func _on_game_restarted() -> void:
	pass

func _on_coin_collected() -> void:
	if (coinsCollected >= COINS_TO_WIN):
		game_ended.emit(GameEndReason.COLLECTED_ALL_COINS)

func _on_world_interaction_shown(_prompt:String) -> void:
	pass

func _on_world_interaction_hidden() -> void:
	pass

func _on_train_interaction_shown(_prompt:String) -> void:
	pass

func _on_train_interaction_hidden() -> void:
	pass

func _on_bandit_roof_position_changed(_index:int) -> void:
	pass