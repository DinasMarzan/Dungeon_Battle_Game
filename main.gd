extends Node2D

@onready var tile_map = $DungeonGrid
@onready var player = $Player
@onready var enemy = $EnemyAI
@onready var item = $Item

func _ready():
	randomize() 
	generate_random_obstacles() 
	tile_map.update_astar()     
	spawn_entities_randomly()   

func generate_random_obstacles():
	var rect = tile_map.get_used_rect()
	var shapes = [
		[Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0)], 
		[Vector2i(0,0), Vector2i(0,1), Vector2i(0,2), Vector2i(1,2), Vector2i(2,2)], 
		[Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(2,2)], 
		[Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)] 
	]
	var attempts = 150 
	var placed_count = 0
	for i in range(attempts):
		if placed_count >= 8: break 
		var start_x = randi_range(rect.position.x + 2, rect.end.x - 3)
		var start_y = randi_range(rect.position.y + 2, rect.end.y - 3)
		var shape = shapes.pick_random()
		var can_place = true
		for offset in shape:
			var pos = Vector2i(start_x, start_y) + offset
			if tile_map.get_cell_source_id(pos) != -1:
				can_place = false
				break
		if can_place:
			for offset in shape:
				var pos = Vector2i(start_x, start_y) + offset
				tile_map.set_cell(pos, 0, Vector2i(0, 0))
			placed_count += 1

func spawn_entities_randomly():
	var valid_cells = []
	var rect = tile_map.get_used_rect()
	for x in range(rect.position.x + 1, rect.end.x - 1):
		for y in range(rect.position.y + 1, rect.end.y - 1):
			if tile_map.get_cell_source_id(Vector2i(x, y)) == -1:
				valid_cells.append(Vector2i(x, y))
	if valid_cells.size() >= 3:
		valid_cells.shuffle() 
		player.position = Vector2(valid_cells[0]) * 128
		enemy.position = Vector2(valid_cells[1]) * 128
		item.position = Vector2(valid_cells[2]) * 128

# ফল খাওয়া শেষ হলে নতুন জায়গায় ফল স্পন করার ফাংশন
func respawn_item():
	var valid_cells = []
	var rect = tile_map.get_used_rect()
	for x in range(rect.position.x + 1, rect.end.x - 1):
		for y in range(rect.position.y + 1, rect.end.y - 1):
			if tile_map.get_cell_source_id(Vector2i(x, y)) == -1:
				valid_cells.append(Vector2i(x, y))
	if valid_cells.size() > 0:
		valid_cells.shuffle()
		item.position = Vector2(valid_cells[0]) * 128
		item.visible = true
