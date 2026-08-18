extends CharacterBody3D


# ==================================================
# PLAYER SETTINGS
# ==================================================

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Hanya 2 lane
const LEFT_LANE_X = -2.0
const RIGHT_LANE_X = 2.0

# Kecepatan pindah lane
const LANE_SPEED = 15.0

# Sedikit toleransi supaya player tetap bisa lompat
# walaupun Godot mendeteksi lantai terlambat.
const GROUND_Y = 1.0
const GROUND_TOLERANCE = 0.15


# ==================================================
# VARIABLES
# ==================================================

var current_lane := 0
# 0 = kiri
# 1 = kanan

var game_over := false
var jump_was_pressed := false


# ==================================================
# MAIN PHYSICS
# ==================================================

func _physics_process(delta: float) -> void:

	# Kalau sudah mati, jangan melakukan apa-apa
	if game_over:
		return


	# ==================================================
	# GRAVITY
	# ==================================================

	if not is_on_floor():
		velocity += get_gravity() * delta


	# ==================================================
	# JUMP
	# SPACE = LOMPAT
	# ==================================================

	var space_pressed := Input.is_physical_key_pressed(KEY_SPACE)

	# Hanya jalankan sekali ketika Space baru ditekan
	if space_pressed and not jump_was_pressed:

		# Bisa lompat kalau menyentuh lantai
		# atau posisi player sangat dekat dengan posisi lantai normal.
		if is_on_floor() or position.y <= GROUND_Y + GROUND_TOLERANCE:

			velocity.y = JUMP_VELOCITY

			print("LOMPAT!")


	jump_was_pressed = space_pressed


	# ==================================================
	# LANE SWITCH
	# ==================================================

	if Input.is_action_just_pressed("ui_left"):

		current_lane = 0


	if Input.is_action_just_pressed("ui_right"):

		current_lane = 1


	# ==================================================
	# TARGET LANE
	# ==================================================

	var target_x := LEFT_LANE_X

	if current_lane == 1:
		target_x = RIGHT_LANE_X


	# ==================================================
	# MOVE TO LANE
	# ==================================================

	position.x = move_toward(
		position.x,
		target_x,
		LANE_SPEED * delta
	)

	# Kita tidak menggunakan velocity.x untuk lane.
	velocity.x = 0.0


	# ==================================================
	# AUTO RUN
	# ==================================================

	velocity.z = -SPEED


	# ==================================================
	# MOVE PLAYER
	# ==================================================

	move_and_slide()


	# ==================================================
	# CHECK COLLISION
	# ==================================================

	for i in get_slide_collision_count():

		var collision := get_slide_collision(i)
		var object := collision.get_collider()

		if object == null:
			continue


		# Cek apakah yang ditabrak adalah obstacle
		if object.is_in_group("obstacle"):

			var normal := collision.get_normal()


			# ==========================================
			# MENYENTUH BAGIAN ATAS OBSTACLE
			# ==========================================
			#
			# Kalau normal mengarah ke atas,
			# berarti player mendarat di atas obstacle.
			# Jangan mati.

			if normal.y > 0.7:
				continue


			# ==========================================
			# MENABRAK SAMPING / DEPAN
			# ==========================================

			die()


# ==================================================
# GAME OVER
# ==================================================

func die() -> void:

	if game_over:
		return


	game_over = true


	# Hentikan player
	velocity = Vector3.ZERO


	print("GAME OVER!")


	# ==================================================
	# TAMPILKAN GAME OVER
	# ==================================================

	var game_over_label = get_node_or_null(
		"../CanvasLayer/GameOverLabel"
	)

	if game_over_label != null:
		game_over_label.visible = true
