extends Node2D

var parent : CharacterBody2D
var speed = 100
var direction : Vector2
var damage
var targetGroup : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = (get_node("iceSprite").global_position - parent.global_position).normalized()
	await get_tree().create_timer(2).timeout
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	if body != parent:
		if body.is_in_group(targetGroup):
			body.hit(damage)
		self.queue_free()
