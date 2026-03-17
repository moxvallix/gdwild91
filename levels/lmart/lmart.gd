extends Node2D

const CHUNK_SIZE = 5
const MAP_WIDTH = 30
const MAP_HEIGHT = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	_generate_walls() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_debug_cell(x_pos: int, y_pos: int, type: int = 0) -> void:
	var types = [
		Vector2i(0, 0),
		Vector2i(5, 1)
	]
	%Floorplan.set_cell(Vector2i(x_pos, y_pos), 0, types[type])

func _generate_walls() -> void:
	var top_left_inset_width := randi() % 2
	var top_left_inset_height := randi() % 8
	
	var top_right_inset_width := randi() % 8
	var top_right_inset_height := randi() % 2
	
	for x in range(0, MAP_WIDTH):
		for y in range(0, MAP_HEIGHT):
			_set_debug_cell(x, y, 1)
			
			if x == 0 or x == (MAP_WIDTH - 1):
				_set_debug_cell(x, y)
			
			if y == 0 or y == (MAP_HEIGHT - 1):
				_set_debug_cell(x, y)
			
			if x <= (1 + top_left_inset_width) and y <= (1 + top_left_inset_height):
				_set_debug_cell(x, y)
			
			if x >= (MAP_WIDTH - 1 - top_right_inset_width) and y <= (1 + top_right_inset_height):
				_set_debug_cell(x, y)

func _generate_entrance_zone() -> void:
	pass
