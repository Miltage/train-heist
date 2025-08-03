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
	$Wheel9.rotation += delta * speed
	$Wheel10.rotation += delta * speed

	_timeElapsed += delta * speed
	if (_timeElapsed > 2.0): _timeElapsed = 0.0

	$Track.position.x = -_timeElapsed * 80

	$Front1.banditOnBoard = playerOnBoard
	$Front2.banditOnBoard = playerOnBoard
	$Front3.banditOnBoard = playerOnBoard
	$Front4.banditOnBoard = playerOnBoard

	_tunnelPos += delta * speed
	$Darkness.position.x = 3000 - _tunnelPos * 80

	if ($Bandit.position.x > $Darkness.position.x && $Bandit.position.x < $Darkness.position.x + $Darkness.size.x && playerOnRoof):
		Globals.game_ended.emit(Globals.GameEndReason.KILLED_IN_TUNNEL)

	if (Input.is_action_just_pressed("interact") && playerCanLeave):
		leave_train()

	$InteractPrompt.position = $Bandit.position - ($InteractPrompt/MousePrompt.size + $InteractPrompt/InteractLabel.size) / 2 - Vector2(0, 150)
	$InteractPrompt.scale = $InteractPrompt.scale.lerp(Vector2.ONE, 0.2)

func _ready() -> void:
	$Bandit.hide()
	$Bandit.position = Vector2(0, 0)
	$InteractPrompt.hide()

	_chests.append($Chest1)
	_chests.append($Chest2)
	_chests.append($Chest3)
	_chests.append($Chest4)

	for chest in _chests:
		chest.bandit_entered.connect(_on_bandit_entered_chest)
		chest.bandit_exited.connect(_on_bandit_exited_chest)
	open_chests()

	_tunnelPos = 5000
	Globals.game_ended.connect(_on_game_ended)	
	Globals.show_train_interaction.connect(_on_interaction_shown)
	Globals.hide_train_interaction.connect(_on_interaction_hidden)

func _on_bandit_entered_chest() -> void:
	$Bandit.hide()

func _on_bandit_exited_chest() -> void:
	$Bandit.show()

func board_train() -> void:
	$Bandit.show()
	$Bandit.dir = 1
	$Bandit.onBoard = true
	$Bandit.position = $Entry.position
	playerOnBoard = true
	playerCanLeave = false

func leave_train() -> void:
	$Bandit.hide()
	$Bandit.onBoard = false
	playerOnBoard = false
	player_left.emit()
	$InteractPrompt.hide()

func _on_board_area_body_entered(body:Node2D) -> void:
	if (body is Bandit): 
		playerCanLeave = true
		Globals.show_train_interaction.emit("leave train")

func _on_board_area_body_exited(body:Node2D) -> void:
	if (body is Bandit): 
		playerCanLeave = false
		Globals.hide_train_interaction.emit()

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

func _on_game_ended(reason:Globals.GameEndReason) -> void:
	if ((reason == Globals.GameEndReason.CAUGHT_BY_SHERIFF || reason == Globals.GameEndReason.FOUND_ON_BOARD)):
		$Bandit.show()

func _on_interaction_shown(prompt:String) -> void:
	if (!playerOnBoard): return
	$InteractPrompt/InteractLabel.text = prompt
	$InteractPrompt.show()
	await get_tree().process_frame
	$InteractPrompt.pivot_offset = ($InteractPrompt/MousePrompt.size + $InteractPrompt/InteractLabel.size)/2
	$InteractPrompt.scale = Vector2.ONE * 1.4

func _on_interaction_hidden() -> void:
	$InteractPrompt.hide()