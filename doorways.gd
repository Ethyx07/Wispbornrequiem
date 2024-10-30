extends "res://Scripts/Interactables/Interactables.gd"

@export var levelToLoad : PackedScene
@export var lockedTexture : Texture2D
@onready var animator = get_node("animPlayer")
@export var bIsUnlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !bIsUnlocked:
		get_node("MainTexture").texture = lockedTexture
	else:
		get_node("MainTexture").texture = baseTexture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(body: Node2D)-> void:
	if bIsUnlocked:
		super(body)
		PlayerData.savePlayerInfo(body.sceneKey, body)
		Gamemode.load_level()
		body.queue_free()
		
		
func highlighted()-> void:
	if bIsUnlocked:
		super()
		
func unhighlighted()-> void:
	if bIsUnlocked:
		super()
	
