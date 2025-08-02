class_name Bandit
extends CharacterBody2D

var speed:float = 100
var dir:float = 1
var overlappingLadder:bool = false
var onLadder:bool = false

func get_input():
    var input_dir = Input.get_axis("steer_left", "steer_right")
    velocity = Vector2(input_dir * speed, velocity.y)

    if (Input.is_action_just_pressed("move_forward")):
        if (overlappingLadder): onLadder = true
        else: velocity.y = -200

    if (velocity.x < 0): dir = -1
    elif (velocity.x > 0): dir = 1

    if (onLadder):
        if (Input.is_action_pressed("move_forward")):
            velocity.y = -100
        elif (Input.is_action_pressed("move_backward")):
            velocity.y = 100
        else: 
            velocity.y = 0

func _physics_process(_delta) -> void:
    if (!overlappingLadder): onLadder = false

    get_input()
    if (!onLadder): velocity.y += 10
    move_and_slide()
    $Sprite2D.flip_h = dir < 0
