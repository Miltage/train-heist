extends Area2D

@export var index:int

func _on_body_entered(body:Node2D) -> void:
	if (body is Bandit):
		Globals.bandit_roof_position_changed.emit(index)

func _on_body_exited(body:Node2D) -> void:
	if (body is Bandit):
		Globals.bandit_roof_position_changed.emit(-1)
