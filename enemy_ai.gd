extends Sprite2D

var grid_size = 128 
var health = 100

@onready var tile_map = $"../DungeonGrid"
@onready var player = $"../Player"
@onready var item = $"../Item" 

func take_turn():
	var ai_grid = tile_map.local_to_map(position)
	var player_grid = tile_map.local_to_map(player.position)
	var dist_to_player = abs(ai_grid.x - player_grid.x) + abs(ai_grid.y - player_grid.y)
	
	# ফলের উপস্থিতি এবং দূরত্বের হিসাব
	var has_item = (item != null and item.visible)
	var dist_to_item = 0
	var item_grid = Vector2i.ZERO
	
	if has_item:
		item_grid = tile_map.local_to_map(item.position)
		dist_to_item = abs(ai_grid.x - item_grid.x) + abs(ai_grid.y - item_grid.y)
		
		# যদি এআই ঠিক ফলের ঘরে বা পাশে থাকে, তবে সঙ্গে সঙ্গে খেয়ে ফেলবে
		if dist_to_item == 1:
			health += 20
			item.visible = false 
			get_parent().respawn_item()
			return

	# --- ডিসিশন ১: এআই দুর্বল হলে (হেলথ আপনার চেয়ে কম হলে) সবার আগে জীবন বাঁচানোর চেষ্টা করবে ---
	if health < player.health:
		if has_item:
			# ফল থাকলে সে ফাইটিংয়ের চিন্তা বাদ দিয়ে সোজা ফলের দিকে দৌড়াবে!
			move_towards(ai_grid, item_grid)
			return
		else:
			# ফল না থাকলে সে উইক অবস্থায় আপনার দিকে তেড়ে আসবে না, দূরে সরে থাকতে চাইবে
			return 

	# --- ডিসিশন ২: প্লেয়ার একদম সামনে (পাশাপাশি) থাকলে এবং এআই দুর্বল না হলে ফাইট করবে ---
	if dist_to_player == 1:
		player.health -= 11 
		if player.health <= 0:
			player.visible = false 
		return 
		
	# --- ডিসিশন ৩: সাধারণ অবস্থায় ফল কাছে থাকলে খাওয়া ---
	if has_item and dist_to_item < dist_to_player:
		move_towards(ai_grid, item_grid)
		return
		
	# --- ডিসিশন ৪: এআই শক্তিশালী (আপনার সমান বা বেশি) হলে সরাসরি প্লেয়ারের দিকে এগিয়ে ফাইট করা ---
	move_towards(ai_grid, player_grid)

func move_towards(start_grid: Vector2i, target_grid: Vector2i):
	var path = tile_map.astar_grid.get_id_path(start_grid, target_grid)
	if path.size() > 1:
		var next_step = path[1]
		if next_step != tile_map.local_to_map(player.position):
			position = Vector2(next_step) * grid_size
