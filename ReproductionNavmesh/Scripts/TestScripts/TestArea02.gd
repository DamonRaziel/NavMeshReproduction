extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.Player_Information = {
	player_name = "Bob",
	player_strength = 10,
	player_speed_max = 6.0,
	player_speed_accel = 3.0,
	player_speed_deaccel = 5.0,
	player_speed_sprint_max = 12.0,
	player_speed_sprint_accel = 6.0,
	player_speed_attack_max = 3.0,
	player_speed_attack_accel = 1.0,
	player_jump = 5.0,
	
	player_current_weapon_number = 0,
	player_current_armour_number = 0,
	player_current_shield_number = 0,
	player_current_helmet_number = 0,
	player_current_item_number = 0,
	
	player_weapon_in_scene = 0,
	player_item_in_scene = 0,
	
	player_inventory_is_full = false,
	
	player_has_flame_burst = false,
	player_has_fireball = false,
	player_has_ice_spike_front = false,
	player_has_ice_spikes_surround = false,
	player_has_quake_spikes = false,
	player_has_crush = false,
	player_has_lightning_throw = false,
	player_has_lightning_surround = false,
	
	player_health = 100,
	player_max_health = 150, 
	player_mana = 50,
	player_max_mana = 70,
	player_lives = 5,
	player_points = 0,
	player_points_bonus = 0,
	player_coins = 0,
	
	player_healing_low_number = 0,
	player_healing_high_number = 0,
	player_manamore_low_number = 0,
	player_manamore_high_number = 0,
	player_elixer_of_strength_number = 0,
	player_elixer_of_speed_number = 0,
	player_elixer_of_fortitude_number = 0,
	player_torches_number = 0,
	shards_collected = 0,
	
	current_level = 1,
	level01unlocked = true,
	level02unlocked = false,
	level03unlocked = false,
	level04unlocked = false,
	level05unlocked = false,
	level06unlocked = false,
	level07unlocked = false,
	level08unlocked = false,
	level09unlocked = false,
	
	spoken_to_castle_mage = false,
	spoken_to_guard01 = false,
	beaten_zombie_boss = false,
	spoken_to_guard02 = false,
	spoken_to_citadel_mage = false,
	spoken_to_boatman = false,
	beaten_davey_jones = false,
	spoken_to_lighthouse_mage = false,
	beaten_creature_boss = false,
	beaten_sorceror_boss = false
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
