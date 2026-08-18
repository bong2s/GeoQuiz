extends CharacterBody2D

@export var left_lane_x: float = 170.0
@export var right_lane_x: float = 370.0

var current_lane: int = 0


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		current_lane = 1

	if Input.is_action_just_pressed("ui_left"):
		current_lane = 0

	if current_lane == 0:
		position.x = left_lane_x
	else:
		position.x = right_lane_x
