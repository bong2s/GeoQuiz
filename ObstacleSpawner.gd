extends Node3D


# =========================================================
# OBSTACLE TEMPLATE
# =========================================================

const OBSTACLE_SCENE = preload("res://obstacle.tscn")


# =========================================================
# PLAYER
# =========================================================

@onready var player = get_parent().get_node_or_null("Player")


# =========================================================
# 2 LANE SAJA
# =========================================================

const LANE_LEFT := -2.0
const LANE_RIGHT := 2.0


# =========================================================
# PENGATURAN SPAWN
# =========================================================

const FIRST_DISTANCE := 25.0

const MIN_DISTANCE := 8.0
const MAX_DISTANCE := 14.0

const SPAWN_AHEAD := 100.0

const DELETE_BEHIND := 30.0

const STARTING_OBSTACLES := 15


var last_spawn_z: float = 0.0


# =========================================================
# MULAI
# =========================================================

func _ready() -> void:

	randomize()

	if player == null:
		print("ERROR: Player tidak ditemukan!")
		return

	print("Obstacle Spawner aktif!")

	# Mulai dari depan player
	last_spawn_z = player.global_position.z - FIRST_DISTANCE

	# Spawn obstacle awal
	for i in range(STARTING_OBSTACLES):
		spawn_obstacle()


# =========================================================
# GAME BERJALAN
# =========================================================

func _process(_delta: float) -> void:

	if player == null:
		return

	# Kalau game over, jangan spawn lagi
	if player.game_over:
		return

	# Selalu isi area di depan player
	while last_spawn_z > player.global_position.z - SPAWN_AHEAD:
		spawn_obstacle()

	# Hapus obstacle yang sudah jauh di belakang
	remove_old_obstacles()


# =========================================================
# SPAWN OBSTACLE RANDOM
# =========================================================

func spawn_obstacle() -> void:

	# -------------------------------------------------------
	# RANDOM PILIH SALAH SATU DARI 2 LANE
	# -------------------------------------------------------

	var lane_x: float

	if randi_range(0, 1) == 0:
		lane_x = LANE_LEFT
	else:
		lane_x = LANE_RIGHT


	# -------------------------------------------------------
	# RANDOM JARAK ANTAR OBSTACLE
	# -------------------------------------------------------

	var distance := randf_range(MIN_DISTANCE, MAX_DISTANCE)

	last_spawn_z -= distance


	# -------------------------------------------------------
	# BUAT OBSTACLE
	# -------------------------------------------------------

	var obstacle = OBSTACLE_SCENE.instantiate()

	if obstacle == null:
		print("ERROR: obstacle.tscn gagal dibuat!")
		return


	# Masukkan ke Main
	get_parent().add_child(obstacle)


	# -------------------------------------------------------
	# POSISI OBSTACLE
	# -------------------------------------------------------

	obstacle.global_position = Vector3(
		lane_x,
		0.5,
		last_spawn_z
	)


	print(
		"OBSTACLE SPAWN | Lane X = ",
		lane_x,
		" | Z = ",
		last_spawn_z
	)


# =========================================================
# HAPUS OBSTACLE YANG SUDAH TERLEWAT
# =========================================================

func remove_old_obstacles() -> void:

	for child in get_parent().get_children():

		# Jangan hapus Player, Arena, dll.
		if not child.is_in_group("obstacle"):
			continue

		# Kalau obstacle sudah jauh di belakang player
		if child.global_position.z > player.global_position.z + DELETE_BEHIND:
			child.queue_free()
