extends Node2D
class_name WorldScene

@onready var doorway = get_node("doorway")
@onready var doorwayHitbox = get_node("doorway/hitbox")
@export var enemyList : Array[PackedScene]
@export var enemySpawns : Array[Node2D]
@export var finalWave : int
@export var spawningIndicator : PackedScene

var player
var bSpawningEnemies = false

var currentWave : int = 0
var bHasSomethingSpawned = false

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	if is_instance_valid(doorway):
		if doorway.bIsUnlocked:
			return
		if get_tree().get_node_count_in_group("Enemy") <= 0:
			if currentWave == finalWave and bHasSomethingSpawned: 
				doorway.animator.play("unlocking")
				await doorway.animator.animation_finished
				doorway.bIsUnlocked = true
				doorwayHitbox.disabled = false
				doorway.get_node("MainTexture").texture = doorway.baseTexture
			else:
				if !bSpawningEnemies:
					bSpawningEnemies = true
					spawnEnemies()
			
func setPlayerLocation(playerNode : Node2D)->void:
	player = playerNode
	player.global_position = get_node("spawnLocation").global_position
	
func _ready() -> void:
	doorwayHitbox.disabled = true
	setPlayerLocation(get_tree().get_first_node_in_group("Player"))
	
func spawnEnemies() -> void:
	bHasSomethingSpawned = false
	currentWave += 1
	var enemyToSpawn : Array[CharacterBody2D]
	var randEnemyCount = randi_range(2, enemySpawns.size())
	for i in randEnemyCount:
		var randEnemyIndex = randi_range(0, enemyList.size()-1)
		var enemyTemp = enemyList[randEnemyIndex].instantiate()
		var spawnPoint = spawningIndicator.instantiate()
		add_child(spawnPoint)
		spawnPoint.global_position = enemySpawns[i].global_position
		enemyToSpawn.append(enemyTemp)
	var spawnIndex = 0
	await get_tree().create_timer(2.5).timeout
	for enemy in enemyToSpawn:
		add_child(enemy)
		enemy.global_position = enemySpawns[spawnIndex].global_position
		spawnIndex += 1
	bSpawningEnemies = false
	bHasSomethingSpawned = true
