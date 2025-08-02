class_name TrainStop
extends Area3D

signal train_entered

func _on_body_entered(body:Node3D) -> void:
	if (body is TrainCar && (body as TrainCar).first):
		train_entered.emit()

func _on_body_exited(_body:Node3D) -> void:
	pass # Replace with function body.