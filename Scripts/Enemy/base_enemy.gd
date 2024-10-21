extends CharacterBody2D

var targetPlayer : CharacterBody2D
@export var speed : float = 200
@export var health : int = 10

@onready var sprite : Sprite2D = get_node("mainTexture")
func _ready() -> void:
	var targetArray = get_tree().get_nodes_in_group("Player")
	targetPlayer = targetArray[0]

func _physics_process(delta: float) -> void:
	if is_instance_valid(targetPlayer):
		var direction = (targetPlayer.global_position - self.global_position).normalized()
		velocity = direction * delta * speed
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		move_and_slide()
	else:
		var targetArray = get_tree().get_nodes_in_group("Player")
		targetPlayer = targetArray[0]
		
func hit(damage) -> void:
	health -= damage
	if health <= 0:
		self.queue_free()
