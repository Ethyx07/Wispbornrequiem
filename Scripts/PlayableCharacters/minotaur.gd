extends "res://Scripts/PlayableCharacters/player_wisp.gd"




func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("Dash") && !bDashing:
		dash()
	
