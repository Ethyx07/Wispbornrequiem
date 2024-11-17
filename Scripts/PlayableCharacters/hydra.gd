extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var leftHeadSprite = get_node("playerSprite/leftHead")
@onready var middleHeadSprite = get_node("playerSprite/middleHead")
@onready var rightHeadSprite = get_node("playerSprite/rightHead")
@onready var hp_bar = get_node("hp_bar")
@onready var uiAnimation = get_node("CanvasLayer/UIAnimation")

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

var currentAttack : attackStates
var bCanSwap : bool = true
var iceSpawns = 10

func _ready() -> void:
	inputVector = Vector2.ZERO
	currentAttack = attackStates.ACID
	hp_bar.max_value = maxHealth
	hp_bar.value = health
	
func loadUI() -> void:
	match currentAttack:
		attackStates.ACID:
			get_node("CanvasLayer/BoxContainer/attackTypes/attackSelect").position = Vector2(0,0)
		attackStates.FIRE:
			get_node("CanvasLayer/BoxContainer/attackTypes/attackSelect").position = Vector2(24,0)
		attackStates.ICE:
			get_node("CanvasLayer/BoxContainer/attackTypes/attackSelect").position = Vector2(48,0)

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
	if Input.is_action_just_pressed("Attack"):
			attack()
		

	
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
			acidAttack()
		attackStates.FIRE:
			fireAttack()
		attackStates.ICE:
			iceAttack()
				

func iceAttack() -> void:
	var firstRotation = 0
	for i in iceSpawns:
			var iceTemp = iceProjectile.instantiate()
			iceTemp.parent = self
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
	fireTemp.fireDamage = fireDamage
	fireTemp.explosionDamage = explosionDamage
	fireTemp.global_position = get_node("attackMarker/attackDirection").global_position
	fireTemp.look_at(get_global_mouse_position())
	get_tree().root.add_child(fireTemp)

func acidAttack() -> void:
	var acidTemp = acidBreath.instantiate()
	acidTemp.global_position = get_node("attackMarker/attackDirection").global_position
	acidTemp.look_at(get_global_mouse_position())
	acidTemp.parent = self
	acidTemp.breathDamage = acidDamage
	acidTemp.poisonDamage = acidPoisonDamage
	acidTemp.poisonTick = poisonTick
	get_tree().root.add_child(acidTemp)
	await get_tree().create_timer(4).timeout
	acidTemp.queue_free()

func hit(damage : int) -> void:
	super(damage)
