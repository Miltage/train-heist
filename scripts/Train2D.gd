extends Node2D

var speed:float = 2

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
    $Chest1.bandit_entered.connect(_on_bandit_entered_chest)
    $Chest2.bandit_entered.connect(_on_bandit_entered_chest)
    $Chest3.bandit_entered.connect(_on_bandit_entered_chest)
    $Chest4.bandit_entered.connect(_on_bandit_entered_chest)
    $Chest1.bandit_exited.connect(_on_bandit_exited_chest)
    $Chest2.bandit_exited.connect(_on_bandit_exited_chest)
    $Chest3.bandit_exited.connect(_on_bandit_exited_chest)
    $Chest4.bandit_exited.connect(_on_bandit_exited_chest)

func _on_bandit_entered_chest() -> void:
    $Bandit.hide()

func _on_bandit_exited_chest() -> void:
    $Bandit.show()