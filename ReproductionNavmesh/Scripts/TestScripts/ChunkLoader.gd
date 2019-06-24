extends Spatial

var chunk_to_load = preload("res://Scenes/TestScenes/Chunk01.tscn")
var chunk_clone

onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	#collision_exception.append(node.get_rid())
	#PlayerData.camera_collision_exceptions.append(self)
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func ignore_this_for_collisions():
	pass

func _on_LoadArea_body_entered(body):
#	if body.has_method("set_collisions"):
#		PlayerData.camera_collision_exceptions.append(self)
#		print(PlayerData.camera_collision_exceptions)
	#detect_chunks
	if body.has_method("process_UI"):
	#if body.has_method("detect_chunks"):
		chunk_clone = chunk_to_load.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(chunk_clone)
		chunk_clone.global_transform = self.global_transform
		print("entered")
		#print(PlayerData.camera_collision_exceptions)

func _on_LoadArea_body_exited(body):
	if body.has_method("process_UI"):
		chunk_clone.queue_free()

func _on_LoadArea_area_entered(area):
	if area.has_method("cam_area_detect"):
		PlayerData.camera_collision_exceptions.append(self)
		print(PlayerData.camera_collision_exceptions)

func _on_LoadArea_area_exited(area):
	if area.has_method("cam_area_detect"):
		#PlayerData.camera_collision_exceptions.remove(self)
		print(PlayerData.camera_collision_exceptions)
