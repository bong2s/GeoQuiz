extends Area2D

var speed := 150.0

func _process(delta):
	position.y += speed * delta


func _on_body_entered(body):
	if body.name == "player":
		get_tree().current_scene.get_node("gameover/Panel").visible = true
		get_tree().current_scene.get_node("gameover/GameOverLabel").visible = true
		get_tree().paused = true
