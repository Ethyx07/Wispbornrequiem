extends Node2D

@export var startingPlayer : PackedScene
@onready var doorway = get_node("doorway")
@onready var doorwayHitbox = get_node("doorway/hitbox")

@export var cameraXMax : float
@export var cameraXMin : float
@export var cameraYMax : float
@export var cameraYMin : float

var bOpened = false
var player : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gamemode.currentLevel = 0
	SaveLogic.save_game(Gamemode.saveSlot, Gamemode.saveName)
	doorway.bIsUnlocked = false
	doorwayHitbox.disabled = true
	player = startingPlayer.instantiate()
	player.global_position = get_node("PlayerSpawn").global_position
	add_child(player)
	var podiums = get_tree().get_nodes_in_group("Podium")
	for podium in podiums:
		podium.bUnlocked = Gamemode.activePodiums[podium.podiumKey]
		podium.setStatus()
		
	player.get_node("Camera2D").limit_left = cameraXMin
	player.get_node("Camera2D").limit_right = cameraXMax
	player.get_node("Camera2D").limit_top = cameraYMin
	player.get_node("Camera2D").limit_bottom = cameraYMax
	
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("Player").sceneKey != "Wisp" and !bOpened:
		doorway.animator.play("unlocking")
		await doorway.animator.animation_finished
		doorway.bIsUnlocked = true
		doorwayHitbox.disabled = false
		doorway.get_node("MainTexture").texture = doorway.baseTexture
		bOpened = true
	
func getLimit(cameraAngle : String ) -> float:
	if cameraAngle == "cameraXMax":
		return cameraXMax
	elif cameraAngle == "cameraXMin":
		return cameraXMin
	elif cameraAngle == "cameraYMax":
		return cameraYMax
	elif cameraAngle == "cameraYMin":
		return cameraYMin
	return 0
	
