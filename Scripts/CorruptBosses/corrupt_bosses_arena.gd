extends Node2D


@onready var healthBar = get_node("CanvasLayer/playergui/healthBar")
@onready var healthBarVal = get_node("CanvasLayer/playergui/healthBar/healthValue")
@onready var bossNameDisplay = get_node("CanvasLayer/playergui/healthBar/bossName")


@export var bossEnemy : PackedScene

var player
var boss
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	boss = bossEnemy.instantiate()
	healthBar.max_value = boss.bossMaxHealth
	healthBar.value = boss.bossMaxHealth
	
	healthBarVal.clear()
	healthBarVal.add_text(str(boss.bossMaxHealth))
	
	bossNameDisplay.clear()
	bossNameDisplay.bbcode_text = "[center]" + boss.bossName + "[/center]"
	
	healthBar.visible = true
	add_child(boss)
	boss.arenaNode = self
	boss.global_position = get_node("BossSpawn").global_position
	setPlayerLocation(get_tree().get_first_node_in_group("Player"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemy") <= 0:
		get_tree().get_first_node_in_group("Player").remove_self()
		get_tree().change_scene_to_file("res://Scenes/hub_scene.tscn")
	
	

func setPlayerLocation(playerNode : Node2D)->void:
	player = playerNode
	player.global_position = get_node("spawnLocation").global_position
	
func updateUI() ->void:
	healthBar.value = boss.currentHealth
	
	healthBarVal.clear()
	healthBarVal.add_text(str(boss.currentHealth))
