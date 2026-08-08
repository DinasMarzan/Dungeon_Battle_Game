extends Sprite2D

var grid_size = 128 
var health = 100

@onready var tile_map = $"../DungeonGrid" 
@onready var enemy_ai = $"../EnemyAI"
@onready var item = $"../Item"

func _unhandled_input(event):
	if health <= 0:
		return 
		
	var direction = Vector2.ZERO
	if event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT 
	elif event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT 
	elif event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN 
	elif event.is_action_pressed("ui_up"):
		direction = Vector2.UP 
		
	if direction != Vector2.ZERO:
		try_move(direction)

func try_move(direction: Vector2):
	var target_pixel_position = position + (direction * grid_size)
	var target_grid_position = tile_map.local_to_map(target_pixel_position)
	
	# --- ১. শত্রুকে অ্যাটাক করা ---
	var enemy_grid = tile_map.local_to_map(enemy_ai.position)
	if target_grid_position == enemy_grid and enemy_ai.health > 0:
		enemy_ai.health -= 10 
		if enemy_ai.health <= 0:
			enemy_ai.visible = false 
		else:
			enemy_ai.take_turn() 
		return 
		
	# --- ২. আইটেম বা ফল সংগ্রহ করা ---
	if item != null and item.visible:
		var item_grid = tile_map.local_to_map(item.position)
		if target_grid_position == item_grid:
			health += 20
			item.visible = false
			get_parent().respawn_item() # নতুন ফল স্পন হবে

	# --- ৩. সাধারণ হাঁটা ---
	var tile_id = tile_map.get_cell_source_id(target_grid_position)
	if tile_id == -1:
		position = target_pixel_position
		if enemy_ai.health > 0:
			enemy_ai.take_turn()
