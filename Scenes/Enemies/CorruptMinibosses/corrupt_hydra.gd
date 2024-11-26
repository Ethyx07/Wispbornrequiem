extends "res://Scripts/CorruptBosses/corrupt_base.gd"

@export var iceProjectile : PackedScene
@export var fireball : PackedScene
@export var acidBreath : PackedScene


var iceDamage : int = 5

var fireDamage : int = 2
var explosionDamage : int = 5

var acidPoisonDamage : int = 1
var acidDamage : int = 1
var poisonTick : int = 1

var attackCooldown : float = 5
var bCanAttack : bool = true
var bHalfAttack : bool = false
var bRageAttackActive : bool = false

func _ready() -> void:
	super()
	currentState = bossState.DEAD
	await get_tree().create_timer(2.5).timeout
	currentState = bossState.CHASE

func _physics_process(delta: float) -> void:
	super(delta)
	if !bRageAttackActive:
		get_node("hitbox").look_at(targetPlayer.global_position)
	if currentState == bossState.DEAD:
		return
	if position.distance_to(targetPlayer.global_position) <= 150:
		var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
		velocity += seperationVector
		if currentState != bossState.ATTACK and currentState != bossState.DEAD:
			poisonAttack()
	else:
		var rand = randi_range(0,10)
		if rand >= 6 and bCanAttack:
			bCanAttack = false
			fireAttack()
			await get_tree().create_timer(0.1).timeout
			if !bRageAttackActive:
				if currentState == bossState.ATTACK and !bRageAttackActive:
					currentState = bossState.CHASE


func iceAttack(bonusRotation : float) -> void:
	var firstRotation = 0
	for i in range(8):
			var iceTemp = iceProjectile.instantiate()
			iceTemp.parent = self
			iceTemp.targetGroup = "Player"
			iceTemp.damage = iceDamage
			iceTemp.deathTimer = 7.5
			iceTemp.global_position = self.global_position
			iceTemp.rotation = get_node("hitbox").rotation
			if i == 0:
				firstRotation = iceTemp.rotation_degrees + bonusRotation
			iceTemp.rotation_degrees = ((360*i)/float(8)) + firstRotation
			call_deferred("addIceToTree", iceTemp)

func addIceToTree(iceTemp : Variant) -> void:
	get_tree().root.add_child(iceTemp)
	
func poisonAttack()->void:
	currentState = bossState.ATTACK
	var acidTemp = acidBreath.instantiate()
	acidTemp.global_position = get_node("hitbox").global_position
	acidTemp.rotation = get_node("hitbox").rotation
	acidTemp.parent = self
	acidTemp.targetGroup = "Player"
	acidTemp.breathDamage = acidDamage
	acidTemp.poisonDamage = acidPoisonDamage
	acidTemp.poisonTick = poisonTick
	get_tree().root.add_child(acidTemp)	
	await get_tree().create_timer(attackCooldown).timeout
	if currentState == bossState.ATTACK and !bRageAttackActive:
		currentState = bossState.CHASE
	
func hit(damage: float) -> void:
	super(damage)
	if currentHealth <= float((bossMaxHealth/2.0)) and !bHalfAttack:
		iceRageAttack()
		speed = speed * 5
		attackCooldown = attackCooldown / 2

func iceRageAttack() -> void:
	currentState = bossState.ATTACK
	bHalfAttack = true
	bRageAttackActive = true
	for i in range(15):
		iceAttack(25 * i)
		targetPlayer.shakeScreen()
		await get_tree().create_timer(0.25).timeout
	bRageAttackActive = false
	
func fireAttack() -> void: 
	currentState = bossState.ATTACK
	var firstRotation = 0
	for i in range(3):
		var fireTemp = fireball.instantiate()
		fireTemp.parent = self
		fireTemp.targetGroup = "Player"
		fireTemp.fireDamage = fireDamage
		fireTemp.explosionDamage = explosionDamage
		fireTemp.global_position = get_node("hitbox").global_position
		fireTemp.get_node("fireballProj").global_position = get_node("hitbox/attackDirection").global_position
		if i == 0:
			firstRotation = fireTemp.rotation_degrees
		elif i == 1:
			fireTemp.rotation_degrees = (15) + firstRotation
		else:
			fireTemp.rotation_degrees = firstRotation - (15) 
		get_tree().root.add_child(fireTemp)
	await get_tree().create_timer(attackCooldown).timeout
	bCanAttack = true
