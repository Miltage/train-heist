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

var holdingCoin:bool = false
var coinsCollected:int = 0
var state:GameState

func _init() -> void:
    game_ended.connect(_on_game_ended)
    game_restarted.connect(_on_game_restarted)

func _on_game_ended(_reason:GameEndReason) -> void:
    state = GameState.OVER
    get_tree().paused = true

func _on_game_restarted() -> void:
    pass