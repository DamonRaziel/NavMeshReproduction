extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	PlayerData.camera_collision_exceptions.append(self)
	#pass

func cam_area_detect():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
