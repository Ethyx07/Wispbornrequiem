extends Control

@onready var statusSprite = get_node("statusSprite")

@export var poisonSprite : Texture2D
@export var charmSprite : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func updateStatusUI(body : CharacterBody2D):
	match body.statusEffect:
		body.statusState.POISON:
			statusSprite.texture = poisonSprite
		body.statusState.CHARM:
			statusSprite.texture = charmSprite
		_:
			hide()
	show()
