class_name EndScreen
extends Control

func _ready() -> void:
	hide()
	Globals.game_ended.connect(_on_game_ended)

func _on_game_ended(reason:Globals.GameEndReason) -> void:
	print("game ended!")

	match (reason):
		Globals.GameEndReason.CAUGHT_BY_SHERIFF: %Reason.text = "You were caught by the sheriff!"
		Globals.GameEndReason.FOUND_ON_BOARD: %Reason.text = "You were found on board!"
		Globals.GameEndReason.KILLED_IN_TUNNEL: %Reason.text = "You were killed in the tunnel!"
		Globals.GameEndReason.COLLECTED_ALL_COINS: %Reason.text = "You collected all 5 coins!"

	match (reason):
		Globals.GameEndReason.CAUGHT_BY_SHERIFF: %Title.text = "YOU LOST!"
		Globals.GameEndReason.FOUND_ON_BOARD: %Title.text = "YOU LOST!"
		Globals.GameEndReason.KILLED_IN_TUNNEL: %Title.text = "YOU DIED!"
		Globals.GameEndReason.COLLECTED_ALL_COINS: %Title.text = "YOU WON!"
	
	show()

func _on_play_again_button_pressed() -> void:
	Globals.game_restarted.emit()
