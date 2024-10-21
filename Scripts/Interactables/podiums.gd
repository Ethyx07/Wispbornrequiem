extends "res://Scripts/Interactables/Interactables.gd"

@export var posssesCharacter : PackedScene
@onready var startingPos : Vector2 = self.global_position
@onready var newPos : Vector2 = startingPos

func _ready() -> void:
	start_bobbing()
	
func start_bobbing():
	var tween = create_tween()
	tween.tween_property(self, "position:y", startingPos.y - 25, 1)
	tween.tween_property(self, "position:y", startingPos.y - 20, 1)
	tween.finished.connect(start_bobbing)
	
func interact(body: Node2D) -> void:
	super(body)
	body.hide()
	var newPossession = posssesCharacter.instantiate()
	newPossession.global_position = body.global_position
	get_tree().root.get_child(0).add_child(newPossession)
	body.queue_free()
	
	
func _physics_process(delta: float) -> void:
	get_node("PodiumUnlocked").global_position = startingPos
	
	
