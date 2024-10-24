extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Special Attack - Minotaur Charge
#velocity = Vector2.ZERO
		#var direction = (get_global_mouse_position() - self.global_position).normalized()
		#velocity = direction * speed * delta * 400
		#bSpecialAttack = true
		##get_node("hurtbox").disabled = true
		#await get_tree().create_timer(1).timeout
		#bSpecialAttack = false
		#get_node("hurtbox").disabled = false
		
## Axe Spin Attack (Circle anim one) - Minotaur
#var axeSpinTemp = axeSpin.instantiate()
	#axeSpinTemp.parent = self
	#add_child(axeSpinTemp)
	#axeSpinTemp.look_at(get_global_mouse_position())
	#axeSpinTemp.get_node("anim_player").play("circle_slash")
	#axeSpinTemp.global_position = get_node("playerSprite").global_position
	#
	#await get_tree().create_timer(0.5).timeout
	#get_node("attackMarker/hitbox/attackbox").disabled = true
	#axeSpinTemp.queue_free()
