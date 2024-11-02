extends Node2D
class_name WorldScene

@onready var doorway = get_node("doorway")

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	if is_instance_valid(doorway):
		if doorway.bIsUnlocked:
			return
		if get_tree().get_node_count_in_group("Enemy") <= 0:
			doorway.animator.play("unlocking")
			await doorway.animator.animation_finished
			doorway.bIsUnlocked = true
			doorway.get_node("MainTexture").texture = doorway.baseTexture
	
