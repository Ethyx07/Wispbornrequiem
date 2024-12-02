extends Node2D

var targetGroup : String = "Player"
var direction
var speed = 250
var target 
var parent

var bStillTracking : bool = true

enum arrowState {NORMAL, BOUNCE, SCATTER, TRACK}
var arrowType : arrowState = arrowState.NORMAL

func _ready() -> void:
	direction = (get_node("forwardDir").global_position - self.global_position).normalized()
	target = get_tree().get_first_node_in_group("Player")
	match arrowType:
		arrowState.NORMAL:
			pass
		arrowState.BOUNCE:
			pass
		arrowState.SCATTER:
			pass
		arrowState.TRACK:
			await get_tree().create_timer(10).timeout
			bStillTracking = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != parent:
		if body.is_in_group(targetGroup):
			body.hit(5)
			self.queue_free()
		elif arrowType == arrowState.BOUNCE:
			var rotationChange = 180 - self.rotation_degrees
			self.rotation_degrees = rotationChange
			direction = (get_node("forwardDir").global_position - self.global_position).normalized()
		else:
			self.queue_free()

func _physics_process(delta: float) -> void:
	self.global_position += direction * speed * delta
	if arrowType == arrowState.TRACK and bStillTracking:
		look_at(target.global_position)
		direction = (get_node("forwardDir").global_position - self.global_position).normalized()
		
	
