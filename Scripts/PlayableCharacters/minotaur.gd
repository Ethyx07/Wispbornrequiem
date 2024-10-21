extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var axeSlash : PackedScene = preload("res://Scenes/WeaponSFX/axe_slash.tscn")

func _ready() -> void:
	get_node("attackMarker/hitbox/attackbox").disabled = true

	

func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("Dash") && !bDashing:
		dash()
	if Input.is_action_just_pressed("Attack"):
		attack()
		
func attack()-> void:
	super()
	get_node("attackMarker/hitbox/attackbox").disabled = false
	var axeTemp = axeSlash.instantiate()
	axeTemp.global_position = get_node("attackMarker/hitbox/attackbox").global_position
	axeTemp.look_at(get_global_mouse_position())
	axeTemp.get_node("axe_anim").play("slash_appear")
	get_tree().root.get_child(0).add_child(axeTemp)
	
	await get_tree().create_timer(0.5).timeout
	get_node("attackMarker/hitbox/attackbox").disabled = true
	axeTemp.queue_free()



	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print(body)
