extends Area

onready var player = get_parent().get_node("Player")

func _ready():
	self.global_transform = player.global_transform

func _process(delta):
	self.global_transform = player.global_transform

func detect_chunks():
	pass
