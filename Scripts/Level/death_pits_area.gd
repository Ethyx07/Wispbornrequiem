extends Area2D


var playerArray : Array[Node2D]


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.currentState == body.playerState.DASH:
			playerArray.append(body)
	


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if playerArray.find(body) >= 0:
			playerArray.remove_at(playerArray.find(body)) # Replace with function body.
		
func _physics_process(_delta: float) -> void:
	if playerArray.size() > 0:
		if playerArray[0].currentState != playerArray[0].playerState.DASH:
			playerArray[0].pitfall()
			playerArray.remove_at(0)
