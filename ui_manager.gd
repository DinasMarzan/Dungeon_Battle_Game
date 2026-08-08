extends CanvasLayer

@onready var player = $"../Player"
@onready var enemy = $"../EnemyAI"
@onready var item = $"../Item"
@onready var player_text = $PlayerHealthText
@onready var enemy_text = $EnemyHealthText
@onready var restart_btn = $RestartButton 
@onready var combat_label = $CombatLabel # কম্ব্যাট সাইন লেবেল

func _ready():
	restart_btn.hide() 
	restart_btn.pressed.connect(reload_game) 
	if combat_label != null:
		combat_label.hide() # শুরুতে লুকিয়ে থাকবে

func _process(delta):
	# ১. প্লেয়ারের হেলথ আপডেট
	if player != null and player.health > 0:
		player_text.text = "Player Health: " + str(player.health)
	elif player != null and player.health <= 0:
		player_text.text = "YOU DIED! GAME OVER"
		player_text.modulate = Color.RED
		restart_btn.show() 
		
	# ২. শত্রুর হেলথ আপডেট
	if enemy != null and enemy.health > 0:
		enemy_text.text = "Enemy Health: " + str(enemy.health)
	elif enemy != null and enemy.health <= 0:
		enemy_text.text = "Enemy Defeated! YOU WIN!"
		enemy_text.modulate = Color.GREEN
		restart_btn.show() 

	# ৩. কম্ব্যাট সাইন সিস্টেম (কাকাছি এলে লেখা উঠবে, দূরে গেলে গায়েব হবে)
	if player != null and enemy != null and player.health > 0 and enemy.health > 0:
		var dist = abs(player.position.x - enemy.position.x)/128 + abs(player.position.y - enemy.position.y)/128
		if dist == 1:
			if combat_label != null: combat_label.show()
		else:
			if combat_label != null: combat_label.hide()
	else:
		if combat_label != null: combat_label.hide()

	# ৪. রাডার সিস্টেম
	if player != null and player.health > 0:
		var radar_info = "RADAR: "
		if enemy != null and enemy.health > 0:
			var enemy_dist = abs(player.position.x - enemy.position.x)/128 + abs(player.position.y - enemy.position.y)/128
			radar_info += "Enemy is " + str(enemy_dist) + " steps away. "
			
		if item != null and item.visible:
			var item_dist = abs(player.position.x - item.position.x)/128 + abs(player.position.y - item.position.y)/128
			radar_info += "| Fruit is " + str(item_dist) + " steps away."
			
		if has_node("RadarText"):
			$RadarText.text = radar_info

func reload_game():
	get_tree().reload_current_scene()
