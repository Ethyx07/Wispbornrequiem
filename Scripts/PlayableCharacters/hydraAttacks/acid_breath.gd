extends Node2D

var breathDamage : int
var poisonDamage : int
var poisonTick : int
var parent : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(4).timeout
	self.queue_free()



func _on_collision_area_body_entered(body: Node2D) -> void:
	if body != parent and body.is_in_group("Enemy"):
		if !body.is_in_group("Boss"):
			body.poisonTickDamage = poisonDamage
			body.poisonTick = poisonTick
			body.statusEffect = body.statusState.POISON
			body.checkStatus()
		body.hit(breathDamage)
