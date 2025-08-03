extends Node2D

func play_coins() -> void:
    $Coins.play()

func play_sheriff_alert() -> void:
    $Sheriff.play()

func play_footstep() -> void:
    $Footstep.play()

func play_roof_footstep() -> void:
    $FootstepRoof.play()

func play_ladder() -> void:
    $Ladder.play()

func start_music() -> void:
    $Music.play()
    $Atmosphere.stop()

func start_end_theme() -> void:
    $Music.stop()
    $Atmosphere.play()

func play_chest_open() -> void:
    $ChestOpen.play()

func play_chest_close() -> void:
    $ChestClose.play()

func play_caught() -> void:
    $Caught.play()

func play_jump() -> void:
    $Jump.play()

func play_gallop() -> void:
    $Gallop.play()

func play_switch() -> void:
    $Switch.play()

func play_horse() -> void:
    $Horse.play()

func play_death() -> void:
    $Death.play()

func play_grab_coin() -> void:
    $GrabCoin.play()

func play_train_horn() -> void:
    $TrainHorn.play()