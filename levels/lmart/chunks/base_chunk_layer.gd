class_name LMartChunkLayer
extends TileMapLayer

func copy_to(tilemap: TileMapLayer, start_pos: Vector2i) -> void:
	for cell: Vector2i in get_used_cells():
		var atlas_pos := get_cell_atlas_coords(cell)
		var new_pos := start_pos + cell
		
		tilemap.set_cell(new_pos, 0, atlas_pos)

func check_valid_spawn(tilemap: TileMapLayer, start_pos: Vector2i) -> bool:
	for cell: Vector2i in get_used_cells():
		if tilemap.get_cell_atlas_coords(start_pos + cell) != Vector2i(-1, -1):
			return false
	
	return true
