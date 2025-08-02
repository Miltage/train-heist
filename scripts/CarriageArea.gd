@tool
extends Area2D

@export var texture:Texture2D : set = set_texture

var banditOverlapping:bool = false

func _on_body_entered(body:Node2D) -> void:
	if (body is Bandit): banditOverlapping = true
	
func _on_body_exited(body:Node2D) -> void:
	if (body is Bandit): banditOverlapping = false

func _process(_delta: float) -> void:
	$Sprite.modulate.a = lerp($Sprite.modulate.a, 0.0 if banditOverlapping else 1.0, 0.1)

func set_texture(newTexture:Texture2D) -> void:
	texture = newTexture
	$Sprite.texture = newTexture