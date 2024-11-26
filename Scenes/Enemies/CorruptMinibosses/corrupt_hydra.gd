extends "res://Scripts/CorruptBosses/corrupt_base.gd"

@export var iceProjectile : PackedScene
@export var fireball : PackedScene

var iceDamage : int = 5
var fireDamage : int = 2
var explosionDamage : int = 5
var bCanAttack : bool = true
var bHalfAttack : bool = false

func _physics_process(delta: float) -> void:
	super(delta)
	if position.distance_to(targetPlayer.global_position) <= 90:
		var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
		velocity += seperationVector
		if currentState != bossState.ATTACK and currentState != bossState.DEAD:
			attack()
			await get_tree().create_timer(1.5).timeout
			currentState = bossState.CHASE
	else:
		var rand = randi_range(0,10)
		if rand >= 6 and currentState != bossState.ATTACK and currentState != bossState.DEAD:
			fireAttack()
			await get_tree().create_timer(5).timeout
			currentState = bossState.CHASE
			
			
func attack() -> void:
	currentState = bossState.ATTACK
	var attackRand = randi_range(0,2)
	match attackRand:
		0:
			iceAttack()
		1:
			fireAttack()
		2:
			print("poison")

func iceAttack() -> void:
	var firstRotation = 0
	for i in range(8):
			var iceTemp = iceProjectile.instantiate()
			iceTemp.parent = self
			iceTemp.targetGroup = "Player"
			iceTemp.damage = iceDamage
			iceTemp.global_position = self.global_position
			iceTemp.rotation = get_node("hitbox").rotation
			if i == 0:
				firstRotation = iceTemp.rotation_degrees
			iceTemp.rotation_degrees = ((360*i)/float(8)) + firstRotation
			get_tree().root.add_child(iceTemp)
	
	
func hit(damage: float) -> void:
	super(damage)
	if currentHealth <= (bossMaxHealth/2) and !bHalfAttack:
		iceRageAttack()

func iceRageAttack() -> void:
	bHalfAttack = true
	iceAttack()
	
func fireAttack() -> void: 
	currentState = bossState.ATTACK
	var firstRotation = 0
	for i in range(3):
		var fireTemp = fireball.instantiate()
		fireTemp.parent = self
		fireTemp.targetGroup = "Player"
		fireTemp.fireDamage = fireDamage
		fireTemp.explosionDamage = explosionDamage
		fireTemp.global_position = self.global_position
		fireTemp.rotation = get_node("hitbox").rotation
		if i == 0:
			firstRotation = fireTemp.rotation_degrees
		elif i == 1:
			fireTemp.rotation_degrees = (15) + firstRotation
		else:
			fireTemp.rotation_degrees = firstRotation - (15) 
		get_tree().root.add_child(fireTemp)
