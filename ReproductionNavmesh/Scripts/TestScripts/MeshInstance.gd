extends MeshInstance

var player

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	self.global_transform.origin.x = player.global_transform.origin.x
	self.global_transform.origin.z = player.global_transform.origin.z
	self.global_transform.origin.y = player.global_transform.origin.y


