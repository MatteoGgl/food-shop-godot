extends Container

onready var tween = get_node("Tween")

func _ready():
	tween.interpolate_property(get_node("Logo"), "rect/pos", Vector2(192,-200), Vector2(192,153), 1.1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()