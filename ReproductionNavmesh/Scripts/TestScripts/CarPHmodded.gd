extends VehicleBody

export var max_engine_force = 200.0
export var max_brake_force = 5.0
export var max_steer_angle = 0.5

export var steer_speed = 5.0
var steer_target = 0.0
var steer_angle = 0.0

export var joy_steering = JOY_ANALOG_LX
export var steering_mult = -1.0
export var joy_throttle = JOY_ANALOG_R2
export var throttle_mult = 1.0
export var joy_brake = JOY_ANALOG_L2
export var brake_mult = 1.0

var vehicle_can_be_entered = false
var vehicle_is_being_controlled = false

onready var player_holder = get_node("PlayerHolder")
onready var player_kickout = get_node("PlayerKickout")
var player 

func something_solid():
	pass

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if vehicle_can_be_entered == true:
			if vehicle_is_being_controlled == false:
				vehicle_is_being_controlled = true
				PlayerData.player_is_controllable = false
				player.global_transform = player_holder.global_transform
				PlayerData.player_is_in_vehicle = 1
				print(PlayerData.player_is_in_vehicle)
			elif vehicle_is_being_controlled == true:
				vehicle_is_being_controlled = false
				PlayerData.player_is_controllable = true
				player.global_transform = player_kickout.global_transform
#				var player_rot = character.get_rotation()
#				player_rot.y = angle
				player.set_player_rotation(0,0,0)
				PlayerData.player_is_in_vehicle = 0
				print(PlayerData.player_is_in_vehicle)
	
	if vehicle_is_being_controlled == true:
		player.global_transform = player_holder.global_transform

func _physics_process(delta):
	var steer_val = steering_mult * Input.get_joy_axis(0, joy_steering)
	var throttle_val = throttle_mult * Input.get_joy_axis(0, joy_throttle)
	var brake_val = brake_mult * Input.get_joy_axis(0, joy_brake)
	
#	if vehicle_is_being_controlled == true:
#		if Input.is_action_pressed("ui_up"):
#			throttle_val = 1.0
#		if Input.is_action_pressed("ui_down"):
#			brake_val = 1.0
#		if Input.is_action_pressed("ui_left"):
#			steer_val = 1.0
#		elif Input.is_action_pressed("ui_right"):
#			steer_val = -1.0
	if vehicle_is_being_controlled == true:
		if Input.is_action_pressed("move_forward"):
			throttle_val = 1.0
		elif Input.is_action_pressed("reload"):
			throttle_val = -1.0
		if Input.is_action_pressed("move_backward"):
			brake_val = 1.0
		elif Input.is_action_pressed("hard_brake"):
			brake_val = 5.0
		if Input.is_action_pressed("move_left"):
			steer_val = 1.0
		elif Input.is_action_pressed("move_right"):
			steer_val = -1.0
	
	engine_force = throttle_val * max_engine_force
	brake = brake_val * max_brake_force
	
	steer_target = steer_val * max_steer_angle
	if (steer_target < steer_angle):
		steer_angle -= steer_speed *  delta
		if (steer_target > steer_angle):
			steer_angle = steer_target
	elif (steer_target > steer_angle):
		steer_angle += steer_speed *  delta
		if (steer_target < steer_angle):
			steer_angle = steer_target
	
	steering = steer_angle

func _on_DoorArea_body_entered(body):
	if body.has_method("process_UI"):
		vehicle_can_be_entered = true

func _on_DoorArea_body_exited(body):
	if body.has_method("process_UI"):
		vehicle_can_be_entered = false
