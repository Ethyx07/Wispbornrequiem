extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var axeSlash : PackedScene = preload("res://Scenes/WeaponSFX/axe_slash.tscn")
@onready var axeSpin : PackedScene = preload("res://Scenes/WeaponSFX/minotaur_slash.tscn")

func _ready() -> void:
	get_node("attackMarker/hitbox/attackbox").disabled = true

	

func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("Dash") && !bDashing:
		dash()
	if Input.is_action_just_pressed("Attack"):
		attack()
	if Input.is_action_just_pressed("SpecialAttack"):
		specialAttack()
		#velocity = Vector2.ZERO
		#var direction = (get_global_mouse_position() - self.global_position).normalized()
		#velocity = direction * speed * delta * 400
		#bSpecialAttack = true
		##get_node("hurtbox").disabled = true
		#await get_tree().create_timer(1).timeout
		#bSpecialAttack = false
		#get_node("hurtbox").disabled = false
	
func attack()-> void:
	super()
	get_node("attackMarker/hitbox/attackbox").disabled = false
	var axeTemp = axeSlash.instantiate()
	axeTemp.parent = self
	add_child(axeTemp)
	axeTemp.global_position = get_node("attackMarker/hitbox/attackbox").global_position
	axeTemp.look_at(get_global_mouse_position())
	axeTemp.get_node("axe_anim").play("slash_appear")
	WorldScene.new().loadNextLevel()
	
	await get_tree().create_timer(0.5).timeout
	get_node("attackMarker/hitbox/attackbox").disabled = true
	axeTemp.queue_free()


func specialAttack() -> void:
	var axeSpinTemp = axeSpin.instantiate()
	axeSpinTemp.parent = self
	add_child(axeSpinTemp)
	axeSpinTemp.look_at(get_global_mouse_position())
	axeSpinTemp.get_node("anim_player").play("circle_slash")
	axeSpinTemp.global_position = get_node("playerSprite").global_position
	
	await get_tree().create_timer(0.5).timeout
	get_node("attackMarker/hitbox/attackbox").disabled = true
	axeSpinTemp.queue_free()
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		pass


func _on_chargebox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and bSpecialAttack:
		body.hit(1)
		body.knockback(velocity)
		print(body.health) # Replace with function body.
