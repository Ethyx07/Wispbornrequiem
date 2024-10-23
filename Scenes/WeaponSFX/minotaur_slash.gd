extends Sprite2D

var parent : CharacterBody2D







func _on_collision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		parent.special_hit(body)
