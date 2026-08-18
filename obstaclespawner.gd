extends Node2D

@export var obstacle_scene: PackedScene

var lanes = [120.0, 350.0]


func _on_obstacle_timer_timeout():
	var obstacle = obstacle_scene.instantiate()

	var lane_x = lanes[randi() % lanes.size()]

	obstacle.position = Vector2(lane_x, -100)

	get_parent().add_child(obstacle)
