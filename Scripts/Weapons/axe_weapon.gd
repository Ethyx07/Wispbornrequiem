extends Sprite2D


enum weaponState {HELD, THROWN, RETURN}

var currentState : weaponState
var owningPlayer : CharacterBody2D
var travelSpeed : float = 100
var travelDist : float = 200
var direction : Vector2

var fixedRotation = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_rotation = deg_to_rad(45)  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match currentState:
		weaponState.HELD:
			if is_instance_valid(owningPlayer):
				self.global_position = owningPlayer.global_position
		weaponState.THROWN:
			get_node("animPlayer").play("spin")
			position += direction * delta * travelSpeed
			if position.distance_to(owningPlayer.global_position) > travelDist:
				currentState = weaponState.RETURN
		weaponState.RETURN:
			var currentRotation = rotation #Gets the current position of the spin animation
			get_node("animPlayer").play("return")
			if !fixedRotation: #Because this looks through always it ensures that this doesnt happen multiple times as it only needs to be fixed once
				rotation = currentRotation #Starts the return spin at the same position as the throw spin was at
				fixedRotation = true
			direction = (owningPlayer.global_position - self.global_position).normalized()
			position += direction * delta * (travelSpeed * 2)
			if position.distance_to(owningPlayer.global_position) < 10:
				get_node("animPlayer").stop()
				currentState = weaponState.HELD
				fixedRotation = false
				global_rotation = deg_to_rad(45)
				owningPlayer.currentState = owningPlayer.playerState.NEUTRAL
		


func _on_hitbox_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Player"):
		if body.has_method("hit"):
			body.hit(owningPlayer.specialDamage)
		currentState = weaponState.RETURN
