extends "res://Scripts/Interactables/Interactables.gd"

var bossKey
var textureIndex

@export var textures : Array[Texture2D]
@export var highlightTextures : Array[Texture2D]

func _ready() -> void:
	match bossKey:
		"Hydra":
			baseTexture = textures[0]
			highlightedTexture = highlightTextures[0]
			get_node("MainTexture").texture = baseTexture
			
func interact(body: Node2D) ->void:
	super(body)
	Gamemode.activePodiums[bossKey] = true
	self.queue_free()
