extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var axeSlash : PackedScene = preload("res://Scenes/WeaponSFX/axe_slash.tscn")
@onready var axeThrow : PackedScene = preload("res://Scenes/Weapons/axe_weapon.tscn")
var heldAxe

func _ready() -> void:
	get_node("attackMarker/hitbox/attackbox").disabled = true
	sceneKey = "Minotaur"
	print(health)
	heldAxe = axeThrow.instantiate()
	heldAxe.owningPlayer = self
	get_tree().root.add_child(heldAxe)
	heldAxe.global_position = self.global_position
	

func _physics_process(delta: float) -> void:
	super(delta)
	match currentState:
		playerState.NEUTRAL:
			if Input.is_action_just_pressed("Dash"):
				dash()
			if Input.is_action_just_pressed("Attack"):
				attack()
			if Input.is_action_just_pressed("SpecialAttack"):
				specialAttack()
				
		
	
func attack()-> void:
	super()
	currentState = playerState.ATTACK
	get_node("attackMarker/hitbox/attackbox").disabled = false
	var axeTemp = axeSlash.instantiate()
	axeTemp.parent = self
	add_child(axeTemp)
	axeTemp.global_position = get_node("attackMarker/hitbox/attackbox").global_position
	axeTemp.look_at(get_global_mouse_position())
	axeTemp.get_node("axe_anim").play("slash_appear")
	await get_tree().create_timer(0.5).timeout
	get_node("attackMarker/hitbox/attackbox").disabled = true
	axeTemp.queue_free()
	currentState = playerState.NEUTRAL


func specialAttack() -> void:
	heldAxe.look_at(get_global_mouse_position())
	heldAxe.currentState = heldAxe.weaponState.THROWN
	heldAxe.direction = (get_global_mouse_position() - get_node("attackMarker").global_position).normalized()
	currentState = playerState.ATTACK
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		pass


func _on_chargebox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.hit(1)
		body.knockback(velocity)
		print(body.health) # Replace with function body.
		
	
