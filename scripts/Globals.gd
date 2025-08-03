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

const COINS_TO_WIN:int = 3

var holdingCoin:bool = false
var coinsCollected:int = 0
var state:GameState

func _init() -> void:
    game_ended.connect(_on_game_ended)
    game_restarted.connect(_on_game_restarted)
    coin_collected.connect(_on_coin_collected)

func _on_game_ended(_reason:GameEndReason) -> void:
    state = GameState.OVER
    get_tree().paused = true

func _on_game_restarted() -> void:
    pass

func _on_coin_collected() -> void:
    if (coinsCollected >= COINS_TO_WIN):
        game_ended.emit(GameEndReason.COLLECTED_ALL_COINS)