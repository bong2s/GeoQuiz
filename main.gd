extends Node3D

const SEGMENT_LENGTH = 30.0
const RECYCLE_DISTANCE = 35.0

@onready var player = $Player

var segments = []


func _ready() -> void:
	segments = [
		$ArenaSegment1,
		$ArenaSegment2,
		$ArenaSegment3
	]


func _process(_delta: float) -> void:

	for segment in segments:

		# Kalau segment sudah jauh di belakang player
		if segment.position.z > player.position.z + RECYCLE_DISTANCE:

			# Cari segment yang paling depan
			var front_z = segments[0].position.z

			for other_segment in segments:
				if other_segment.position.z < front_z:
					front_z = other_segment.position.z

			# Pindahkan segment ke depan
			segment.position.z = front_z - SEGMENT_LENGTH
