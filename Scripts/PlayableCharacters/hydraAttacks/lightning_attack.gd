extends Node2D

@onready var sprite = get_node("sprite")
@onready var zapRadius = get_node("detection/zapRadius")

var target : CharacterBody2D
var parent : CharacterBody2D

var hitList : Array[CharacterBody2D]
var enemyInAOE : Array[CharacterBody2D]
var chainCount : int = 0
var totalChain = 3
# Called when the node enters the scene tree for the first time.
func interpolate(length : float, duration : float) -> void:
	var tween_offset = get_tree().create_tween()
	var tween_rect_h = get_tree().create_tween()
	tween_offset.tween_property(sprite, "offset", Vector2(length/2.0, 0), duration)
	tween_rect_h.tween_property(sprite, "region_rect",Rect2(0,9,length, 12), duration)
	
func spark(distance : float) -> void:
	if is_instance_valid(target):
		self.look_at(target.position)
		interpolate(distance, 0.2)
		await get_tree().create_timer(0.2).timeout
		zapRadius.global_position = target.global_position
		hit(target)
		interpolate(0, 0.1)
		await get_tree().create_timer(0.1).timeout	
	

func hit(current_target : CharacterBody2D) -> void:
	chainCount += 1
	hitList.append(current_target)
	current_target.hit(3)
	if current_target.is_in_group("Boss"):
		return
	current_target.statusEffect = current_target.statusState.STUN
	current_target.checkStatus()
	if chainCount < totalChain:
		enemyInAOE.clear()
		zapRadius.disabled = false
		await get_tree().create_timer(0.1).timeout
		zapRadius.disabled = true
		var dist = 9999
		var tempTarget
		for enemy in enemyInAOE:
			var tempDist = target.global_position.distance_to(enemy.global_position)
			if tempDist < dist:
				dist = tempDist
				tempTarget = enemy
		var nextTarget = tempTarget
		if is_instance_valid(nextTarget):
			self.global_position = current_target.global_position
			target = nextTarget
			spark(self.global_position.distance_to(target.global_position))
		else:
			hitList.clear()
	else:
		hitList.clear()	

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and !hitList.has(body) and !enemyInAOE.has(body):
		enemyInAOE.append(body)
