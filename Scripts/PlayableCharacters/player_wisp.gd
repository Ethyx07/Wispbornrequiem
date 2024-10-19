extends CharacterBody2D

@export var speed : float = 20.0


@onready var playerSprite = get_node("playerSprite")

var facingBody : Node2D

func _physics_process(delta: float) -> void:
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	inputVector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	if inputVector.x < 0:
		#faces to the left
		playerSprite.flip_h = true
		get_node("InteractableBox/interact_box_left").disabled = false
		get_node("InteractableBox/interact_box_right").disabled = true
	elif inputVector.x > 0:
		#faces to the right
		playerSprite.flip_h = false
		get_node("InteractableBox/interact_box_left").disabled = true
		get_node("InteractableBox/interact_box_right").disabled = false
	velocity = inputVector * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("Interact"):
		if is_instance_valid(facingBody):
			facingBody.interact(get_node("."))
	if Input.is_action_just_pressed("Dash"):
		velocity = velocity * 100
		move_and_slide()

func _on_interactable_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Interactable") and !is_instance_valid(facingBody):
		facingBody = body
		facingBody.highlighted()

func _on_interactable_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Interactable") and is_instance_valid(facingBody):
		facingBody.unhighlighted()
		facingBody = null
