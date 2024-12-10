extends Node2D


@onready var healthBar = get_node("CanvasLayer/playergui/healthBar")
@onready var healthBarVal = get_node("CanvasLayer/playergui/healthBar/healthValue")
@onready var bossNameDisplay = get_node("CanvasLayer/playergui/healthBar/bossName")
@onready var doorway = get_node("doorway")
@onready var doorwayHitbox = get_node("doorway/hitbox")

@export var bossEnemy : PackedScene

@export var cameraXMax : float
@export var cameraXMin : float
@export var cameraYMax : float
@export var cameraYMin : float

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
	doorwayHitbox.disabled = true
	player.get_node("Camera2D").limit_left = cameraXMin
	player.get_node("Camera2D").limit_right = cameraXMax
	player.get_node("Camera2D").limit_top = cameraYMin
	player.get_node("Camera2D").limit_bottom = cameraYMax

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemy") <= 0 and get_tree().get_node_count_in_group("Trophy") <= 0:
		if !doorway.bIsUnlocked:
			doorway.animator.play("unlocking")
			await doorway.animator.animation_finished
			doorway.bIsUnlocked = true
			doorwayHitbox.disabled = false
			doorway.get_node("MainTexture").texture = doorway.baseTexture
	
	

func setPlayerLocation(playerNode : Node2D)->void:
	player = playerNode
	player.global_position = get_node("spawnLocation").global_position
	
func updateUI() ->void:
	healthBar.value = boss.currentHealth
	
	healthBarVal.clear()
	healthBarVal.add_text(str(boss.currentHealth))
	if healthBar.value <= 0:
		await get_tree().create_timer(2.5).timeout
		healthBar.hide()
