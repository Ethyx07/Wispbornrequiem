extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var axeSlash : PackedScene = preload("res://Scenes/WeaponSFX/axe_slash.tscn")
@onready var axeThrow : PackedScene = preload("res://Scenes/Weapons/axe_weapon.tscn")
@onready var hp_bar = get_node("hp_bar")
@onready var armour_bar = get_node("hp_bar/armour_bar")
@onready var specialCooldownNode = get_node("CanvasLayer/specialCooldown")
@onready var cooldownTimer = get_node("cooldownTimer")

@export var maxArmourPoints : int = 10

var armourPoints = 0
var direction


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
	if !inputEnabled:
		return
	match currentState:
		playerState.NEUTRAL:
			if Input.is_action_just_pressed("Dash"):
				direction = dash()
			get_node("hurtbox").disabled = false
			if Input.is_action_just_pressed("Attack"):
				attack()
			if Input.is_action_just_pressed("SpecialAttack"):
				specialAttack()
			if Input.is_action_just_pressed("ActivateUlt"):
				ultActivate()
		playerState.DASH:
			velocity = direction * speed * delta * 300
			self.collision_layer = 0
			self.collision_layer = (1 << 2)
			self.collision_mask = 0
			self.collision_mask = (1 << 2)
			move_and_slide()
			await get_tree().create_timer(0.5).timeout
			self.collision_layer = (1 << 0) | (1 << 1) | (1 << 2)
			self.collision_mask = (1 << 0) | (1 << 1) | (1 << 2)
			currentState = playerState.NEUTRAL	
			#pitCheck()
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
	if currentDevice == controllerState.KBM:
		axeTemp.look_at(get_global_mouse_position())
	else:
		axeTemp.rotation = get_node("attackMarker").rotation
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
	if currentDevice == controllerState.KBM:
		heldAxe.look_at(get_global_mouse_position())
		heldAxe.direction = (get_global_mouse_position() - get_node("attackMarker").global_position).normalized()
	else:
		heldAxe.rotation = get_node("attackMarker").rotation
		heldAxe.direction = (get_node("attackMarker/attackDirection").global_position - get_node("attackMarker").global_position).normalized()
	heldAxe.currentState = heldAxe.weaponState.THROWN
	
	currentState = playerState.ATTACK
	
func startSpecialCooldown() ->void:
	cooldownTimer.wait_time = specialCooldown
	cooldownTimer.start()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		pass


		
func hit(damageTaken : int)-> void:
	if currentState == playerState.DASH:
		return
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
		super(damageTaken)
	hp_bar.value = health


func _on_cooldown_timer_timeout() -> void:
	if !bCanUseSpecial:
		bCanUseSpecial = true
		return

func remove_self() -> void:
	heldAxe.queue_free()
	self.queue_free()
