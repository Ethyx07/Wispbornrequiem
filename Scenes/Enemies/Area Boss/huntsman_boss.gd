extends "res://Scripts/CorruptBosses/corrupt_base.gd"

@export var arrow : PackedScene
var target
var bCanAttack: bool = false
var attackCooldown : float = 4.5
	
func _ready() -> void:
	super()
	target = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(5).timeout
	bCanAttack = true	
	
func _physics_process(delta: float) -> void:
	super(delta)
	if currentState == bossState.DEAD:
		return
	get_node("hitbox").look_at(target.global_position)
	if bCanAttack:
		bCanAttack = false
		attackSelector()
		await get_tree().create_timer(attackCooldown).timeout
		bCanAttack = true	

func spawnArrow(spawnPos : Vector2) -> void:
	var arrowTemp = arrow.instantiate()
	arrowTemp.global_position = spawnPos
	arrowTemp.look_at(target.global_position)
	arrowTemp.targetGroup = "Player"
	arrowTemp.parent = self
	var rand = randi_range(0, 3)
	match rand:
		0:
			arrowTemp.arrowType = arrowTemp.arrowState.NORMAL
		1:
			arrowTemp.arrowType = arrowTemp.arrowState.BOUNCE
		2:
			arrowTemp.arrowType = arrowTemp.arrowState.SCATTER
		3:
			arrowTemp.arrowType = arrowTemp.arrowState.TRACK
	var speedChance = randi_range(0, 10)
	if speedChance >= 7:
		arrowTemp.speed = arrowTemp.speed * 1.5
		arrowTemp.playSpeedAnim()
	self.get_parent().add_child(arrowTemp)

func hit(damage : float)-> void:
	super(damage)
	
func attackSelector() ->void:
	var randNum = randi_range(0, 10)
	if randNum >= 0:
		triAttack()
	else:
		spawnArrow(get_node("hitbox/attackDirection").global_position)

func triAttack()->void:
	var curPosition = get_node("hitbox/attackDirection").global_position
	var spawnNum = 2 * (bossMaxHealth/currentHealth)
	if spawnNum > 6: 
		spawnNum = 6
	for i in range(1):
		spawnArrow(curPosition)
		await get_tree().create_timer(0.2).timeout
