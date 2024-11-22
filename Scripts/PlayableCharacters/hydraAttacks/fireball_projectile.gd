extends Node2D

@onready var explosionAnim = get_node("explosionAnim")
@onready var explosionHitbox = get_node("explosionRadius/explosionShape")
@onready var collisionHitbox = get_node("fireballProj/collisionArea/collisionShape")

var parent : CharacterBody2D
var direction
var speed = 100
var fireDamage
var explosionDamage

var bIsExploding = false
var targetGroup : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosionHitbox.disabled = true
	direction = (self.global_position - parent.global_position).normalized()
	await get_tree().create_timer(3).timeout
	if !bIsExploding:
		explosionHandler()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !bIsExploding:
		self.global_position += direction * speed * delta


func _on_collision_area_body_entered(body: Node2D) -> void:
	if body != parent:
		if body.is_in_group(targetGroup):
			body.hit(fireDamage) 
		call_deferred("explosionHandler")

func explosionHandler() ->void:
	bIsExploding = true
	collisionHitbox.disabled = true
	explosionHitbox.disabled = false
	explosionAnim.play("explosion")
	await explosionAnim.animation_finished
	self.queue_free()

func _on_explosion_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group(targetGroup):
		body.hit(explosionDamage) # Replace with function body.
