extends CharacterBody2D

var targetPlayer : CharacterBody2D
var bKnockedback : bool = false
@export var speed : float = 200
@export var health : int = 10

@onready var sprite : Sprite2D = get_node("mainTexture")

func _ready() -> void:
	var targetArray = get_tree().get_nodes_in_group("Player")
	targetPlayer = targetArray[0]

func _physics_process(delta: float) -> void:
	if is_instance_valid(targetPlayer):
		if !bKnockedback:
			var direction = (targetPlayer.global_position - self.global_position).normalized()
			velocity = direction * delta * speed
			if position.distance_to(targetPlayer.global_position) < 50:
				var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
				velocity += seperationVector
			if direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			move_and_slide()
		else:
			move_and_slide()
	else:
		var targetArray = get_tree().get_nodes_in_group("Player")
		targetPlayer = targetArray[0]
		
func hit(damage : int) -> void:
	health -= damage
	if health <= 0:
		get_node("AnimationPlayer").play("death")
		await get_node("AnimationPlayer").animation_finished
		self.queue_free()
		
func knockback(knockbackVector : Vector2) -> void:
	var knockbackForce = knockbackVector.normalized()
	velocity = knockbackForce * 50
	bKnockedback = true
	await get_tree().create_timer(5).timeout
	bKnockedback = false
