extends Area2D


func _on_body_entered(body:Node2D) -> void:
	if (body is Bandit):
		(body as Bandit).overlappingLadder = true


func _on_body_exited(body:Node2D) -> void:
	if (body is Bandit):
		(body as Bandit).overlappingLadder = false
