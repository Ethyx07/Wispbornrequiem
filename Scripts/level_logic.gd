extends Node2D
class_name WorldScene

@onready var doorway = get_node("doorway")
@export var enemyList : Array[PackedScene]
@export var enemySpawns : Array[Node2D]
@export var finalWave : int

var player
var bSpawningEnemies = false

var currentWave : int = 0

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	if is_instance_valid(doorway):
		if doorway.bIsUnlocked:
			return
		if get_tree().get_node_count_in_group("Enemy") <= 0:
			if currentWave == finalWave:
				doorway.animator.play("unlocking")
				await doorway.animator.animation_finished
				doorway.bIsUnlocked = true
				doorway.get_node("MainTexture").texture = doorway.baseTexture
			else:
				if !bSpawningEnemies:
					bSpawningEnemies = true
					await get_tree().create_timer(5).timeout
					spawnEnemies()
			
func setPlayerLocation(playerNode : Node2D)->void:
	player = playerNode
	player.global_position = get_node("spawnLocation").global_position
	
func _ready() -> void:
	setPlayerLocation(get_tree().get_first_node_in_group("Player"))
	
func spawnEnemies() -> void:
	currentWave += 1
	var randEnemyCount = randi_range(2, enemySpawns.size())
	for i in randEnemyCount:
		var randEnemyIndex = randi_range(0, enemyList.size()-1)
		var enemyTemp = enemyList[randEnemyIndex].instantiate()
		add_child(enemyTemp)
		enemyTemp.global_position = enemySpawns[i].global_position
	bSpawningEnemies = false
