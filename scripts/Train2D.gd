extends Node2D

signal player_left

var speed:float = 2
var playerCanLeave:bool = false

func _process(delta: float) -> void:
	$Wheel1.rotation += delta * speed
	$Wheel2.rotation += delta * speed
	$Wheel3.rotation += delta * speed
	$Wheel4.rotation += delta * speed
	$Wheel5.rotation += delta * speed
	$Wheel6.rotation += delta * speed
	$Wheel7.rotation += delta * speed
	$Wheel8.rotation += delta * speed

func _ready() -> void:
	$Bandit.hide()
	$Bandit.position = Vector2(0, 0)
	$Chest1.bandit_entered.connect(_on_bandit_entered_chest)
	$Chest2.bandit_entered.connect(_on_bandit_entered_chest)
	$Chest3.bandit_entered.connect(_on_bandit_entered_chest)
	$Chest4.bandit_entered.connect(_on_bandit_entered_chest)
	$Chest1.bandit_exited.connect(_on_bandit_exited_chest)
	$Chest2.bandit_exited.connect(_on_bandit_exited_chest)
	$Chest3.bandit_exited.connect(_on_bandit_exited_chest)
	$Chest4.bandit_exited.connect(_on_bandit_exited_chest)
	hide_coin()

func _on_bandit_entered_chest() -> void:
	$Bandit.hide()

func _on_bandit_exited_chest() -> void:
	$Bandit.show()

func board_train() -> void:
	$Bandit.show()
	$Bandit.dir = 1
	$Bandit.position = $Entry.position

func leave_train() -> void:
	$Bandit.hide()
	player_left.emit()

func _on_board_area_body_entered(body:Node2D) -> void:
	if (body is Bandit): playerCanLeave = true

func _on_board_area_body_exited(body:Node2D) -> void:
	if (body is Bandit): playerCanLeave = false

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact") && playerCanLeave):
		leave_train()

func hide_coin() -> void:
	$Chest1.close(false)
	$Chest2.close(true)
	$Chest3.close(false)
	$Chest4.close(false)