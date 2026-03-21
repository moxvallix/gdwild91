class_name CollectedItem
extends Node2D

const SPEED := 4.0
const COLLECT_RADIUS = 20.0

var start_pos: Vector2
var end_pos: Vector2
var total_distance: float

func _ready() -> void:
	start_pos = position
	total_distance = start_pos.distance_to(end_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(end_pos, delta * SPEED)
	
	var distance = position.distance_to(end_pos)
	var percent = (distance / total_distance)
	modulate.a = percent
	scale = Vector2(percent, percent)
	
	if distance < COLLECT_RADIUS:
		queue_free()
