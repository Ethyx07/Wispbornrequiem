extends "res://Scripts/CorruptBosses/corrupt_base.gd"

@export var arrow : PackedScene
var target

func hit(damage : float)-> void:
	super(damage)
	
func _ready() -> void:
	super()
	target = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(5).timeout
	spawnArrow(get_node("hitbox/attackDirection").global_position)
	
func spawnArrow(spawnPos : Vector2) -> void:
	var arrowTemp = arrow.instantiate()
	arrowTemp.global_position = spawnPos
	arrowTemp.look_at(target.global_position)
	arrowTemp.targetGroup = "Player"
	arrowTemp.parent = self
	var rand = randi_range(0, 3)
	match rand:
		0:
			arrowTemp.arrowType = arrowTemp.arrowState.NORMAL
		1:
			arrowTemp.arrowType = arrowTemp.arrowState.BOUNCE
		2:
			arrowTemp.arrowType = arrowTemp.arrowState.SCATTER
		3:
			arrowTemp.arrowType = arrowTemp.arrowState.TRACK
	var speedChance = randi_range(0, 10)
	if speedChance >= 7:
		arrowTemp.speed = arrowTemp.speed * 1.5
		arrowTemp.playSpeedAnim()
	get_tree().root.add_child(arrowTemp)
	await get_tree().create_timer(10).timeout
	spawnArrow(get_node("hitbox/attackDirection").global_position)


func _physics_process(delta: float) -> void:
	super(delta)
	get_node("hitbox").look_at(target.global_position)
