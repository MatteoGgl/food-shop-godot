extends TextureButton

func _ready():
	connect("pressed", get_node("/root/Game"), "_button_pressed", [self.get_name()])