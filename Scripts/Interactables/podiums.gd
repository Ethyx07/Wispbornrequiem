extends "res://Scripts/Interactables/Interactables.gd"

@export var posssesCharacter : PackedScene
@onready var startingPos : Vector2 = self.global_position

@export var bUnlocked : bool = true
@export var bSaved : bool = false
@export var podiumKey : String

@export var lockedTexture : Texture2D
@export var unlockedTexture : Texture2D
@export var savedTexture : Texture2D
@export var lockedRelicTexture : Texture2D


func _ready() -> void:
	get_node("MainTexture").global_position.y = startingPos.y - 25
	if bUnlocked or bSaved:
		start_bobbing()
		if bUnlocked and !bSaved:
			get_node("PodiumTexture").texture = unlockedTexture
		else:
			get_node("PodiumTexture").texture = savedTexture
	else:
		get_node("PodiumTexture").texture = lockedTexture
		get_node("MainTexture").texture = lockedRelicTexture
	
func start_bobbing():
	var tween = create_tween()
	tween.tween_property(self, "position:y", startingPos.y - 2, 1)
	tween.tween_property(self, "position:y", startingPos.y + 2, 1)
	tween.finished.connect(start_bobbing)
	
func interact(body: Node2D) -> void:
	if bUnlocked:
		super(body)
		if body.sceneKey != podiumKey:
			body.hide()
			var newPossession = posssesCharacter.instantiate()
			newPossession.global_position = body.global_position
			get_tree().root.get_child(0).add_child(newPossession)
			body.queue_free()
	
	
func _physics_process(_delta: float) -> void:
	get_node("PodiumTexture").global_position = startingPos
	get_node("hitbox").global_position = startingPos
	
func highlighted() -> void:
	if bUnlocked:
		super()
	
func unhighlighted() -> void:
	if bUnlocked:
		super()
