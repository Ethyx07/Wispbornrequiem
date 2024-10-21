extends "res://Scripts/PlayableCharacters/player_wisp.gd"




func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("Dash"):
		#Creates particle where the player leaves from
		var particle_temp = dashParticle.instantiate()
		particle_temp.emitting = true
		particle_temp.global_position = playerSprite.global_position
		get_tree().root.get_child(0).add_child(particle_temp)
		playerSprite.hide()
		#Gets position of mouse relative to player location for dash (allows dashing over blocked areas)
		var dashPosition = (get_global_mouse_position() - self.global_position).normalized() * dashSpeed
		self.global_position += dashPosition
		#Delay for when the player reappears to give better visual on the dash
		await get_tree().create_timer(0.1).timeout
		#Creates the instance of the dash particle where the player reappears
		var particle_tempFin = dashParticle.instantiate()
		particle_tempFin.emitting = true
		particle_tempFin.global_position = playerSprite.global_position
		get_tree().root.get_child(0).add_child(particle_tempFin)
		playerSprite.show()
	
