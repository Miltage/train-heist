class_name Main
extends Node3D

@export var track:Path3D
@export var train:Train

func _ready() -> void:
	train.player_boarded.connect(_on_player_boarded_train)
	$Train2D.player_left.connect(_on_player_disembarked_train)
	$SaloonStop.train_entered.connect(_on_train_reached_stop)
	$BankStop.train_entered.connect(_on_train_reached_stop)
	Globals.game_restarted.connect(_on_game_restarted)
	Globals.coin_collected.connect(_on_coin_collected)

	Globals.holdingCoin = false
	Globals.coinsCollected = 0

	# while(true):
	# 	await get_tree().create_timer(1.0).timeout
	# 	Globals.coinsCollected += 1
	# 	Globals.coin_collected.emit()

func _process(_delta: float) -> void:
	$HorseDust.position = $Player.position
	$HorseDust.emitting = $Player.velocity.length() > 1.0 || $Player.boarded
	$CoinsLabel.scale = lerp($CoinsLabel.scale, Vector2.ONE, 0.3)
	$CoinIcon.scale = lerp($CoinsLabel.scale, Vector2.ONE, 0.4)

func _on_player_boarded_train() -> void:
	if ($Player.boarded): return
	$Player.boarded = true
	$Train2D.board_train()

func _on_player_disembarked_train() -> void:
	$Player.boarded = false

func _on_train_reached_stop() -> void:
	train.stop()

func _on_train_stopped() -> void:
	if ($Train2D.player_can_be_found()):
		Globals.game_ended.emit(Globals.GameEndReason.FOUND_ON_BOARD)
	else:
		if (train.get_pos().x < 0): $Train2D.hide_coin()
		else: $Train2D.open_chests()

func _on_game_restarted() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_tunnel_body_entered(body:Node3D) -> void:
	if (body is TrainCar && (body as TrainCar).first): 
		$Train2D.enter_tunnel()

func _on_coin_collected() -> void:
	$CoinsLabel.text = "%d / %d" % [Globals.coinsCollected, Globals.COINS_TO_WIN]
	$CoinsLabel.pivot_offset = $CoinsLabel.size / 2
	$CoinsLabel.scale = Vector2.ONE * 1.5
	$CoinIcon.scale = Vector2.ONE * 1.5