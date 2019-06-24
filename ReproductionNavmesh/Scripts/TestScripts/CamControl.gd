extends Spatial

onready var y_rotator = get_node("CamRotY")
onready var x_rotator = get_node("CamRotY/CamRotX")
onready var camera = get_node("CamRotY/CamRotX/Camera2")
onready var player = get_parent()

var MOUSE_SENSITIVITY = 0.5

var distance_to_camera = 4.0
var wanted_distance_to_camera = 4.0
#var collision_exceptions = []
export var distance = 4.0
export var closest_distance = 0.5
export var furthest_distance = 8
export var height = 2.0
export var aiming_distance = 0.7
export var non_aiming_distance = 4.0

func _ready():
	set_as_toplevel(true)
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	self.global_transform.origin = player.global_transform.origin
	
	var target1 = camera.get_global_transform().origin
	var pos1 = x_rotator.get_global_transform().origin
	var up1 = Vector3(0,1,0)

	var offset1 = pos1-target1
	offset1 = offset1.normalized()*distance
	pos1 = target1+offset1
	
	if PlayerData.current_player_aiming_style == 0:
		if distance > non_aiming_distance:
			distance -= 0.1
		elif distance < non_aiming_distance:
			distance += 0.1
		if Input.is_action_pressed("ui_up"): #closer
			if distance > closest_distance:
				distance -= 0.1
				non_aiming_distance = distance
		if Input.is_action_pressed("ui_down"): #further
			if distance < furthest_distance:
				distance += 0.1
				non_aiming_distance = distance
	elif PlayerData.current_player_aiming_style == 1:
		if distance > aiming_distance:
			distance -= 0.1
	var new_cam_dist = Vector3(0,0,-distance)
#	camera.set_translation(new_cam_dist)
	#look_at_from_position(pos1, target1, up1)
	
	#var ray = get_node("RayCast")
	var ray = get_node("CamRotY/CamRotX/RayCast")
	ray.add_exception(x_rotator)
#	ray.add_exception(get_parent().get_parent().get_parent())
	ray.set_cast_to(target1)
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		var col_pos = ray.get_collision_point()
		#colpos is vector3
		#set_translation(collider.global_transform)
		#camera.set_translation(col_pos)
		print(col_pos)
		#var col_vector3_origin = col_pos.origin
		
		var col_pos_dist = x_rotator.global_transform.origin.distance_to(col_pos)
		print (col_pos_dist)
		
		var temp_cam_dist = Vector3(0,0,col_pos_dist)
		camera.set_translation(temp_cam_dist)
	else:
		camera.set_translation(new_cam_dist)
	
	
#	collision_exceptions.append(x_rotator)
	
#	var space_state = get_world().get_direct_space_state()
#	var obstacle = space_state.intersect_ray(camera.get_translation(),  x_rotator.get_translation(), collision_exceptions)
#	if not obstacle.empty():
#		camera.set_translation(obstacle.position)

func _input(event):
    if event is InputEventMouseMotion:# and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        x_rotator.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
        y_rotator.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = x_rotator.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        x_rotator.rotation_degrees = camera_rot
