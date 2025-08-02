extends Node2D

signal player_left

@export var train:Train

var speed:float = 2
var playerCanLeave:bool = false
var playerOnBoard:bool = false
var playerOnRoof:bool = false

var _chests:Array
var _timeElapsed:float
var _tunnelPos:float

func _process(delta: float) -> void:
	speed = train.speed * 5
	$Wheel1.rotation += delta * speed
	$Wheel2.rotation += delta * speed
	$Wheel3.rotation += delta * speed
	$Wheel4.rotation += delta * speed
	$Wheel5.rotation += delta * speed
	$Wheel6.rotation += delta * speed
	$Wheel7.rotation += delta * speed
	$Wheel8.rotation += delta * speed

	_timeElapsed += delta * speed
	if (_timeElapsed > 2.7): _timeElapsed = 0.0

	$Track.position.x = -_timeElapsed * 80

	$Front1.banditOnBoard = playerOnBoard
	$Front2.banditOnBoard = playerOnBoard
	$Front3.banditOnBoard = playerOnBoard
	$Front4.banditOnBoard = playerOnBoard

	_tunnelPos += delta * speed
	$Darkness.position.x = 3000 - _tunnelPos * 80

	if (Input.is_action_just_pressed("interact") && playerCanLeave):
		leave_train()

func _ready() -> void:
	$Bandit.hide()
	$Bandit.position = Vector2(0, 0)

	_chests.append($Chest1)
	_chests.append($Chest2)
	_chests.append($Chest3)
	_chests.append($Chest4)

	for chest in _chests:
		chest.bandit_entered.connect(_on_bandit_entered_chest)
		chest.bandit_exited.connect(_on_bandit_exited_chest)
	open_chests()

	_tunnelPos = 5000

func _on_bandit_entered_chest() -> void:
	$Bandit.hide()

func _on_bandit_exited_chest() -> void:
	$Bandit.show()

func board_train() -> void:
	$Bandit.show()
	$Bandit.dir = 1
	$Bandit.position = $Entry.position
	playerOnBoard = true
	playerCanLeave = false

func leave_train() -> void:
	$Bandit.hide()
	playerOnBoard = false
	player_left.emit()

func _on_board_area_body_entered(body:Node2D) -> void:
	if (body is Bandit): playerCanLeave = true

func _on_board_area_body_exited(body:Node2D) -> void:
	if (body is Bandit): playerCanLeave = false

func hide_coin() -> void:
	for chest in _chests:
		chest.close(false)

	var random_chest:Chest = _chests.pick_random()
	random_chest.close(true)

func open_chests() -> void:
	for chest in _chests:
		chest.open()

func _on_roof_area_body_entered(body: Node2D) -> void:
	if (body is Bandit): playerOnRoof = true

func _on_roof_area_body_exited(body: Node2D) -> void:
	if (body is Bandit): playerOnRoof = false

func player_can_be_found() -> bool:
	return playerOnBoard && !playerOnRoof

func enter_tunnel() -> void:
	_tunnelPos = 0
