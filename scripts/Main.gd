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

func _process(_delta: float) -> void:
	pass

func _on_player_boarded_train() -> void:
	$Player.boarded = true
	$Train2D.board_train()

func _on_player_disembarked_train() -> void:
	$Player.boarded = false

func _on_train_reached_stop() -> void:
	train.stop()

func _on_train_stopped() -> void:
	if ($Train2D.player_can_be_found()):
		Globals.game_ended.emit(Globals.GameEndReason.FOUND_ON_BOARD)

	if (train.get_pos().x < 0): $Train2D.hide_coin()
	else: $Train2D.open_chests()

func _on_game_restarted() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_tunnel_body_entered(body:Node3D) -> void:
	if (body is TrainCar && (body as TrainCar).first): 
		print("train entered tunnel")
		$Train2D.enter_tunnel()
