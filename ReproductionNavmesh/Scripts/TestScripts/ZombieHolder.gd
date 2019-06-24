extends KinematicBody

var accel 
var DEACCEL = 1.0
const ACCEL = 1.0
var MAX_ATTACK_SPEED = 0.0
var MAX_SPRINT_SPEED = 2.0
var MAX_SPEED = 1.5
var is_sprinting = false
var speed = 1.5
var enemy_origin
var enemy
var gravity = -9.8
var velocity = Vector3()
var zombie_damage = 20
var can_attack_timer = 0.0
var can_attack_time = 10.5
var attacking = false
var attack_timer = 0.0
var attack_time = 3.5
var current_health = 100
var max_health = 100
var health_to_recover = 5 # hp recovered if nt hit
var retreat_health = 25 # hp at which enemy will try to escape
var chance_of_attack = 0
var chance_of_attack_blocked = 0
var enemy_fort = 5
var enemy_lightning_res = 5
var enemy_ice_res = 5
var enemy_fire_res = 500
var enemy_earth_res = 5
var target = null
var navmesh
var path = []
var begin = Vector3()
var end = Vector3()
var waypoint_numbers_to_choose_from
var waypoint_number_chosen
var enemy_state = 0
#0 = idle, 1 = wander randomly, 2 = chase player, 3 = attack player, 4 = retreat
var decision
var is_active = false
var zombie_dying = false
onready var nav = get_parent().get_parent()

func _ready():
	enemy = get_node(".")
	navmesh = get_parent().get_parent()

func _process(delta):
	#deals with movement when using navmesh
	#--Chasing Player--#
	if enemy_state == 2:
		if (path.size() > 1):
			var to_walk = delta*speed
			var to_watch = Vector3(0, 1, 0)
			while(to_walk > 0 and path.size() >= 2):
				var pfrom = path[path.size() - 1]
				var pto = path[path.size() - 2]
				to_watch = (pto - pfrom).normalized()
				var d = pfrom.distance_to(pto)
				if (d <= to_walk):
					path.remove(path.size() - 1)
					to_walk -= d
				else:
					path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
					to_walk = 0
				var atpos = path[path.size() - 1]
				var atdir = to_watch
				atdir.y = 0
				var t = Transform()
				t.origin = atpos
				t=t.looking_at(atpos + atdir, Vector3(0, 1, 0))
				self.set_transform(t)
				if (path.size() < 2):
					path = []
					calculate_path()
		else:
			set_process(false)
	#----End of Movement Section----#

func _physics_process(delta):
	#deals with enemy movement when attacking the player
	#----Enemy Movement Setion----#
	enemy_origin = enemy.get_global_transform().origin
	var offset = Vector3()
	if target != null:
		offset = target.get_global_transform().origin - enemy_origin
	else:
		offset = null
	var dir = Vector3()
	if target != null:
		dir += offset
		dir.y = 0
		dir = dir.normalized()
	else:
		dir = null
	velocity.y += delta*gravity
	var hv = velocity
	hv.y = 0
	var mtarget
	if target != null:
		mtarget = dir
	else:
		mtarget = 0
	attacking = false
	if attacking == true:
		mtarget *= MAX_ATTACK_SPEED
	elif attacking == false:
		if is_sprinting:
			mtarget *= MAX_SPRINT_SPEED
		else:
			mtarget *= MAX_SPEED
	var ATTACK_ACCEL = 1
	var SPRINT_ACCEL = 2
	if target != null:
		if dir.dot(hv) > 0:
			if attacking == true:
				accel = ATTACK_ACCEL
			elif attacking == false:
				if is_sprinting:
					accel = SPRINT_ACCEL
				else:
					accel = ACCEL
		else:
			accel = DEACCEL
		hv = hv.linear_interpolate(mtarget, accel*delta)
		velocity.x = hv.x
		velocity.z = hv.z
	#----End of Movement Section----#
	#----Attack Section----#
	#enemy attack
	if enemy_state == 3:
		velocity = move_and_slide(Vector3(0,0,0), Vector3(0,1,0))
		var angle = atan2(-hv.x, -hv.z)
		var char_rot = enemy.get_rotation()
		char_rot.y = angle
		enemy.set_rotation(char_rot)
		if can_attack_timer >=can_attack_time:
			if attack_timer>=attack_time:
				attacking = true
				zombie_attack()
			else:
				attacking = false
	if can_attack_timer<can_attack_time:
		can_attack_timer += 0.06
	if enemy_state == 3:
		if attack_timer<attack_time:
			attack_timer += 0.06
	if zombie_dying == true:
		queue_free()

func zombie_attack():
	var area = $Area
	var bodies = area.get_overlapping_bodies()
	var damage
	damage = zombie_damage
	for abody in bodies:
		if abody == self:
			continue
		if abody.has_method("process_UI"):
			abody._hit(damage, 0, area.global_transform.origin)
	can_attack_timer = 0.0
	attack_timer = 0.0

func _on_Detect_Area_body_entered(body):
	if body.has_method("process_UI"):
		if current_health >= retreat_health:
			print ("enemy detect area entered")
			target = body
			enemy_state = 2
			calculate_path()
		else:
			pick_retreat_waypoint()

func _on_Detect_Area_body_exited(body):
	if current_health > 0:
		if body.has_method("process_UI"):
			target = null
			idle_for_a_moment()

func _on_Attack_Area_body_entered(body):
	if body.has_method("process_UI"):
		enemy_state = 3
		set_physics_process(true)
		set_process(false)

func _on_Attack_Area_body_exited(body):
	if body.has_method("process_UI"):
		if current_health >= retreat_health:
			target = body
			enemy_state = 2
			calculate_path()
		else:
			pick_retreat_waypoint()

func _hit(damage, type, _hit_pos):
	if current_health > 0:
		randomize()
		var hit_points_lost
		if type == 0:
			hit_points_lost = damage - enemy_fort
			hit_points_lost = clamp(hit_points_lost, 0, 500)
			current_health -= hit_points_lost
		elif type == 1:
			hit_points_lost = damage - enemy_lightning_res
			hit_points_lost = clamp(hit_points_lost, 0, 500)
			current_health -= hit_points_lost
		elif type == 2:
			hit_points_lost = damage - enemy_ice_res
			hit_points_lost = clamp(hit_points_lost, 0, 500)
			current_health -= hit_points_lost
		elif type == 3:
			hit_points_lost = damage - enemy_fire_res
			hit_points_lost = clamp(hit_points_lost, 0, 500)
			current_health -= hit_points_lost
		elif type == 4:
			hit_points_lost = damage - enemy_earth_res
			hit_points_lost = clamp(hit_points_lost, 0, 500)
			current_health -= hit_points_lost
		chance_of_attack = randi()%100+1
		chance_of_attack_blocked = ((damage*2)-enemy_fort)
		if chance_of_attack <= chance_of_attack_blocked:
			can_attack_timer = 0.0
		PlayerData.points_add(damage)
		if current_health < retreat_health:
			pick_retreat_waypoint()
		if current_health <= 0:
			zombie_die()

func zombie_die():
	zombie_dying = true
	set_physics_process(true)

func idle_for_a_moment():
	enemy_state = 0
	set_physics_process(false)
	set_process(false)

func pick_waypoint():
#	currently not needed
	idle_for_a_moment()

func pick_retreat_waypoint():
#	currently not needed
	idle_for_a_moment()

func calculate_path():
	begin = navmesh.get_closest_point(self.get_translation())
	end = navmesh.get_closest_point(target.get_translation())
#	print ("begin is : ", begin)
#	print ("end is : ", end)
#	print ("and end target is : ", end_target)
	var p = navmesh.get_simple_path(begin, end, true)
	path = Array(p)
	path.invert()
	set_process(true)
	set_physics_process(false)

func _on_Map_Area_body_entered(body):
	if body.has_method("process_UI"):
		is_active = true
	else:
		pass

func _on_Map_Area_body_exited(body):
	if body.has_method("process_UI"):
		is_active = false
	else:
		pass
