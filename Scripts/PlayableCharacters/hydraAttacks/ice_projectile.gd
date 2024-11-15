extends Node2D

var parent : CharacterBody2D
var speed = 100
var direction : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = (get_node("iceSprite").global_position - parent.global_position).normalized()
	await get_tree().create_timer(2).timeout
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
