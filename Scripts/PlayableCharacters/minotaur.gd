extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var axeSlash : PackedScene = preload("res://Scenes/WeaponSFX/axe_slash.tscn")
@onready var axeThrow : PackedScene = preload("res://Scenes/Weapons/axe_weapon.tscn")
@onready var hp_bar = get_node("hp_bar")
@onready var armour_bar = get_node("hp_bar/armour_bar")
@onready var specialCooldownNode = get_node("CanvasLayer/specialCooldown")
@onready var cooldownTimer = get_node("cooldownTimer")

@export var maxArmourPoints : int = 10

var armourPoints = 0


var heldAxe

func _ready() -> void:
	get_node("attackMarker/hitbox/attackbox").disabled = true
	sceneKey = "Minotaur"
	hp_bar.max_value = maxHealth
	hp_bar.value = health
	
	armour_bar.max_value = maxArmourPoints
	armour_bar.value = 0

	heldAxe = axeThrow.instantiate()
	heldAxe.owningPlayer = self
	get_tree().root.add_child(heldAxe)
	heldAxe.global_position = self.global_position
	
	specialCooldownNode.max_value = specialCooldown
	specialCooldownNode.value = specialCooldown
	

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
			if Input.is_action_just_pressed("ActivateUlt"):
				ultActivate()
				
	if !bCanUseSpecial and currentState == playerState.NEUTRAL:
		specialCooldownNode.value = specialCooldown - cooldownTimer.time_left
	
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

func ultActivate() -> void:
	super()
	armourPoints = maxArmourPoints
	armour_bar.value = armourPoints

func specialAttack() -> void:
	if !bCanUseSpecial:
		return
	bCanUseSpecial = false
	specialCooldownNode.value = 0
	heldAxe.look_at(get_global_mouse_position())
	heldAxe.currentState = heldAxe.weaponState.THROWN
	heldAxe.direction = (get_global_mouse_position() - get_node("attackMarker").global_position).normalized()
	currentState = playerState.ATTACK
	
func startSpecialCooldown() ->void:
	cooldownTimer.wait_time = specialCooldown
	cooldownTimer.start()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		pass


		
func hit(damageTaken : int)-> void:
	if bUlting:
		armourPoints -=	damageTaken
		if armourPoints >= 0:
			if armourPoints == 0:
				bUlting = false
			armour_bar.value = armourPoints	
		else:
			super(armourPoints * -1) #Checks if the damage does more than the full armour. If it does the remainder is dealt to hp
			armourPoints = 0
			armour_bar.value = armourPoints
	else:
		health -= damageTaken
	hp_bar.value = health


func _on_cooldown_timer_timeout() -> void:
	if !bCanUseSpecial:
		bCanUseSpecial = true
		return
