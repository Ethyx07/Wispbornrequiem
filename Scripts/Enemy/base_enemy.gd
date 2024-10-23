extends CharacterBody2D

var targetPlayer : CharacterBody2D
var bKnockedback : bool = false
var bCanMove : bool = true
@export var speed : float = 200
@export var health : int = 10
@export var attackDelay : float = 0.2

@onready var sprite : Sprite2D = get_node("mainTexture")

func _ready() -> void:
	var targetArray = get_tree().get_nodes_in_group("Player")
	targetPlayer = targetArray[0]
	get_node("hitbox/attackbox").disabled = true

func _physics_process(delta: float) -> void:
	if is_instance_valid(targetPlayer) and bCanMove:
		if !bKnockedback:
			var direction = (targetPlayer.global_position - self.global_position).normalized()
			velocity = direction * delta * speed
			if position.distance_to(targetPlayer.global_position) < 50:
				var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
				velocity += seperationVector
				attack()
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
	bCanMove = false
	await get_tree().create_timer(0.2).timeout
	bCanMove = true
		
func knockback(knockbackVector : Vector2) -> void:
	var knockbackForce = knockbackVector.normalized()
	velocity = knockbackForce * 50
	bKnockedback = true
	await get_tree().create_timer(5).timeout
	bKnockedback = false
	
func attack():
	bCanMove = false
	await get_tree().create_timer(attackDelay).timeout
	get_node("hitbox/attackbox").disabled = false
	get_node("hitbox").look_at(targetPlayer.global_position)
	await get_tree().create_timer(0.01).timeout
	get_node("hitbox/attackbox").disabled = true
	await get_tree().create_timer(0.01).timeout
	bCanMove = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.health -= 1 
	print(body.health)
