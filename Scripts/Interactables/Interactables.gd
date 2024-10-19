extends Node

@export var itemDesc: String
@export var highlightedTexture : Texture2D
@export var baseTexture : Texture2D
@export var posssesCharacter : PackedScene


func _ready() -> void:
	pass

func interact(body: Node2D) -> void:
	body.hide()
	var newPossession = posssesCharacter.instantiate()
	newPossession.global_position = body.global_position
	get_tree().root.get_child(0).add_child(newPossession)
	body.queue_free()
	
	
func highlighted() -> void:
	get_node("Wisp").texture = highlightedTexture
	
func unhighlighted() -> void:
	get_node("Wisp").texture = baseTexture
