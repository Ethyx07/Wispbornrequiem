extends Node2D

@onready var animPlayer = get_node("animPlayer")
@onready var sprite = get_node("sprite")
@onready var rayNode = get_node("rayNode")

@export var normTexture : Texture2D
@export var bounceTexture : Texture2D
@export var scatterTexture : Texture2D
@export var trackTexture : Texture2D

var targetGroup : String = "Player"
var direction : Vector2
var speed : float = 250
var target : CharacterBody2D
var parent : CharacterBody2D
var maxBounce : int = 5
var bounceCount : int = 0

var bStillTracking : bool = true

enum arrowState {NORMAL, BOUNCE, SCATTER, TRACK}
var arrowType : arrowState = arrowState.NORMAL

func _ready() -> void:
	direction = (get_node("forwardDir").global_position - self.global_position).normalized()
	target = get_tree().get_first_node_in_group("Player")
	match arrowType:
		arrowState.NORMAL:
			sprite.texture = normTexture
		arrowState.BOUNCE:
			sprite.texture = bounceTexture
		arrowState.SCATTER:
			sprite.texture = scatterTexture
		arrowState.TRACK:
			sprite.texture = trackTexture
			animPlayer.play("trackAnim")
			await get_tree().create_timer(10).timeout
			bStillTracking = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != parent:
		if body.is_in_group(targetGroup):
			body.hit(5)
			self.queue_free()
		elif arrowType == arrowState.BOUNCE:
			bounceCount += 1
			if bounceCount >= maxBounce:
				self.queue_free()
				return
			#var rotationChange = rotationCalc(self.rotation_degrees) will use later
			look_at(target.global_position)
			direction = (get_node("forwardDir").global_position - self.global_position).normalized()
		else:
			self.queue_free()

func _physics_process(delta: float) -> void:
	self.global_position += direction * speed * delta
	if rayNode.is_colliding():
		var collider = rayNode.get_collider()
		var hitObject
		if collider.is_in_group("Projectile"):
			hitObject = collider
		if collider.get_parent().is_in_group("Projectile"):
			hitObject = collider.get_parent()
		if hitObject:
			if hitObject.parent != self.parent:
				self.queue_free()
	if arrowType == arrowState.TRACK and bStillTracking:
		look_at(target.global_position)
		direction = (get_node("forwardDir").global_position - self.global_position).normalized()
		

func playSpeedAnim()->void:
	get_node("sprite/speedSprite").visible = true
	get_node("speedAnim").play("speedyAnim")
	
