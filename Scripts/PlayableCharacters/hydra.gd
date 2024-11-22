extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var leftHeadSprite = get_node("playerSprite/leftHead")
@onready var middleHeadSprite = get_node("playerSprite/middleHead")
@onready var rightHeadSprite = get_node("playerSprite/rightHead")
@onready var hp_bar = get_node("hp_bar")
@onready var uiAnimation = get_node("CanvasLayer/UIAnimation")
@onready var poisonNode = get_node("CanvasLayer/BoxContainer/poisonAttack")
@onready var fireNode = get_node("CanvasLayer/BoxContainer/fireAttack")
@onready var iceNode = get_node("CanvasLayer/BoxContainer/iceAttack")

@export var iceProjectile = preload("res://Scenes/PlayerClasses/hydraAttacks/ice_projectile.tscn")
@export var fireballProjectile = preload("res://Scenes/PlayerClasses/hydraAttacks/fireball_projectile.tscn")
@export var acidBreath = preload("res://Scenes/PlayerClasses/hydraAttacks/acid_breath.tscn")

enum attackStates {ACID, FIRE, ICE}

@export var fireDamage : int
@export var explosionDamage : int
@export var iceDamage : int
@export var acidDamage : int
@export var acidPoisonDamage : int
@export var poisonTick : int
@export var breathCooldown : int
@export var fireballCooldown : int
@export var iceCooldown : int

@export var iceTexture : Texture2D
@export var iceDisabled : Texture2D
@export var fireTexture : Texture2D
@export var fireDisabled : Texture2D
@export var poisonTexture : Texture2D
@export var poisonDisabled : Texture2D

var currentCooldown : int
var direction

var currentAttack : attackStates
var bCanSwap : bool = true
var bIceReady : bool = true
var bFireReady : bool = true
var bPoisonReady : bool = true
var iceSpawns = 10

func _ready() -> void:
	inputVector = Vector2.ZERO
	currentAttack = attackStates.ACID
	hp_bar.max_value = maxHealth
	hp_bar.value = health
	currentState = playerState.NEUTRAL
	
func loadUI() -> void:
	match currentAttack:
		attackStates.ACID:
			get_node("CanvasLayer/BoxContainer/poisonAttack/attackSelect").position = Vector2(0,0)
		attackStates.FIRE:
			get_node("CanvasLayer/BoxContainer/poisonAttack/attackSelect").position = Vector2(24,0)
		attackStates.ICE:
			get_node("CanvasLayer/BoxContainer/poisonAttack/attackSelect").position = Vector2(48,0)

func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		if inputVector.x >= 0:
			playerSprite.flip_h = true
			leftHeadSprite.flip_h = true
			middleHeadSprite.flip_h = true
			rightHeadSprite.flip_h = true
		else:
			playerSprite.flip_h = false
			leftHeadSprite.flip_h = false
			middleHeadSprite.flip_h = false
			rightHeadSprite.flip_h = false
	if Input.is_action_just_pressed("SpecialAttack"):
		changeAttackType()
	match currentState:
		playerState.NEUTRAL:
			if Input.is_action_just_pressed("Attack"):
				attack()
			if Input.is_action_just_pressed("Dash"):
				direction = dash()
		playerState.DASH:
			velocity = direction * speed * delta * 50
			self.collision_layer = 0
			self.collision_layer = (1 << 2)
			self.collision_mask = 0
			self.collision_mask = (1 << 2)
			move_and_slide()
			await get_tree().create_timer(0.5).timeout
			self.collision_layer = (1 << 0) | (1 << 1) | (1 << 2)
			self.collision_mask = (1 << 0) | (1 << 1) | (1 << 2)
			currentState = playerState.NEUTRAL	

	
func changeAttackType() -> void:
	if bCanSwap:
		bCanSwap = false
		match currentAttack:
			attackStates.ACID:
				uiAnimation.play("middleSelect")
				currentAttack = attackStates.FIRE
			attackStates.FIRE:
				uiAnimation.play("rightSelect")
				currentAttack = attackStates.ICE
			attackStates.ICE:
				uiAnimation.play("leftSelect")
				currentAttack = attackStates.ACID
		await uiAnimation.animation_finished
		bCanSwap = true

func attack() -> void:
	currentState = playerState.ATTACK
	match currentAttack:
		attackStates.ACID:
			if bPoisonReady:
				acidAttack()
				updateUI(attackStates.ACID)
		attackStates.FIRE:
			if bFireReady:
				fireAttack()
				updateUI(attackStates.FIRE)
		attackStates.ICE:
			if bIceReady:
				iceAttack()
				updateUI(attackStates.ICE)
	currentState = playerState.NEUTRAL
				

func iceAttack() -> void:
	var firstRotation = 0
	for i in iceSpawns:
			var iceTemp = iceProjectile.instantiate()
			iceTemp.parent = self
			iceTemp.targetGroup = "Enemy"
			iceTemp.damage = iceDamage
			iceTemp.global_position = self.global_position
			iceTemp.look_at(get_global_mouse_position())
			if i == 0:
				firstRotation = iceTemp.rotation_degrees
			iceTemp.rotation_degrees = ((360*i)/float(iceSpawns)) + firstRotation
			get_tree().root.add_child(iceTemp)
			
func fireAttack() -> void:
	var fireTemp = fireballProjectile.instantiate()
	fireTemp.parent = self
	fireTemp.targetGroup = "Enemy"
	fireTemp.fireDamage = fireDamage
	fireTemp.explosionDamage = explosionDamage
	fireTemp.global_position = get_node("attackMarker/attackDirection").global_position
	fireTemp.look_at(get_global_mouse_position())
	get_tree().root.add_child(fireTemp)

func acidAttack() -> void:
	var acidTemp = acidBreath.instantiate()
	acidTemp.global_position = get_node("attackMarker").global_position
	acidTemp.look_at(get_global_mouse_position())
	acidTemp.parent = self
	acidTemp.targetGroup = "Enemy"
	acidTemp.breathDamage = acidDamage
	acidTemp.poisonDamage = acidPoisonDamage
	acidTemp.poisonTick = poisonTick
	get_tree().root.add_child(acidTemp)
	
func updateUI(attackStat : attackStates)->void:
	match attackStat:
		attackStates.ICE:
			if bIceReady:
				bIceReady = false
				iceNode.texture = iceDisabled
				await get_tree().create_timer(iceCooldown).timeout
				updateUI(attackStat)
			else:
				bIceReady = true
				iceNode.texture = iceTexture
		attackStates.FIRE:
			if bFireReady:
				bFireReady = false
				fireNode.texture = fireDisabled
				await get_tree().create_timer(fireballCooldown).timeout
				updateUI(attackStat)
			else:
				bFireReady = true
				fireNode.texture = fireTexture
		attackStates.ACID:
			if bPoisonReady:
				bPoisonReady = false
				poisonNode.texture = poisonDisabled
				await get_tree().create_timer(breathCooldown).timeout
				updateUI(attackStat)
			else:
				bPoisonReady = true
				poisonNode.texture = poisonTexture


func hit(damage : int) -> void:
	super(damage)
