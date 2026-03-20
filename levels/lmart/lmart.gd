extends Node2D

const CHUNK_SIZE = 5
const MAP_WIDTH = 80
const MAP_HEIGHT = 50

const CHUNK_LIST = [
	"res://levels/lmart/chunks/test_1.tscn",
	"res://levels/lmart/chunks/test_2.tscn",
	"res://levels/lmart/chunks/test_3.tscn",
	"res://levels/lmart/chunks/test_4.tscn",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_generate_walls() 
	_test_load()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_debug_cell(x_pos: int, y_pos: int, type: int = 0) -> void:
	var types = [
		Vector2i(0, 0),
		Vector2i(5, 1)
	]
	%Floorplan.set_cell(Vector2i(x_pos, y_pos), 0, types[type])

func _test_load() -> void:
	var chunks: Array = CHUNK_LIST.map(func(path): return load(path).instantiate())
	chunks.map(func(chunk): chunk._ready())
	
	var width := 30
	var height := 40
	var gap := 1
	
	var x := 0
	var y := 0
	
	var tallest := 0
	
	while y < height:
		while x < width:
			var chunk: LMartChunk = chunks.pick_random()
			var check := chunk.check_valid_spawn(%Tiles, Vector2i(x, y))
			
			if check:
				chunk.copy_to(%Tiles, Vector2i(x, y))
				var size := chunk.floorplan.get_used_rect().size
				x += size.x + gap
				
				if size.y > tallest:
					tallest = size.y
			else:
				x += 1
		y += tallest + gap
		x = randi() % 2
		tallest = 0

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
