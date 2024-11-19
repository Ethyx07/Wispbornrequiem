extends Node2D

@export var startingPlayer : PackedScene
@onready var doorway = get_node("doorway")
@onready var doorwayHitbox = get_node("doorway/hitbox")

var bOpened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gamemode.currentLevel = 0
	SaveLogic.save_game(Gamemode.saveSlot, Gamemode.saveName)
	doorway.bIsUnlocked = false
	doorwayHitbox.disabled = true
	var player = startingPlayer.instantiate()
	player.global_position = get_node("PlayerSpawn").global_position
	add_child(player)
	var podiums = get_tree().get_nodes_in_group("Podium")
	for podium in podiums:
		podium.bUnlocked = Gamemode.activePodiums[podium.podiumKey]
		podium.setStatus()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("Player").sceneKey != "Wisp" and !bOpened:
		doorway.animator.play("unlocking")
		await doorway.animator.animation_finished
		doorway.bIsUnlocked = true
		doorwayHitbox.disabled = false
		doorway.get_node("MainTexture").texture = doorway.baseTexture
		bOpened = true
