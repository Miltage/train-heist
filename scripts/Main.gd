class_name Main
extends Node3D

@export var track:Path3D
@export var train:Train

func _ready() -> void:
	train.player_boarded.connect(_on_player_boarded_train)
	$Train2D.player_left.connect(_on_player_disembarked_train)

func _process(_delta: float) -> void:
	pass

func _on_player_boarded_train() -> void:
	$Player.boarded = true
	$Train2D.board_train()

func _on_player_disembarked_train() -> void:
	$Player.boarded = false