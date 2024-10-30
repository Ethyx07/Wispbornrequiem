extends Sprite2D

var parent : CharacterBody2D
var hit_player = []


func _on_attackbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !hit_player.has(body):
		hit_player.append(body)
		parent.attack_hit(body)
