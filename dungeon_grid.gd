extends TileMapLayer

var astar_grid: AStarGrid2D

func _ready():
	update_astar()

# এই ফাংশনটি ম্যাপের দেয়ালগুলোকে A* অ্যালগরিদমের কাছে আপডেট করে দেয়
func update_astar():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(-50, -50, 100, 100)
	astar_grid.cell_size = Vector2i(128, 128)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

	# যেসব জায়গায় দেয়াল আছে, সেগুলোকে ব্লক করে দেওয়া
	var walls = get_used_cells()
	for wall in walls:
		astar_grid.set_point_solid(wall, true)
