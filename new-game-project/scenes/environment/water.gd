extends AnimatedSprite2D
var fixed_pos: Vector2

func _ready():
	fixed_pos = global_position

func _process(_delta):
	# Counteract parent's scale so this node stays fixed size
	scale = Vector2(0.5, 1) / get_parent().scale
	global_position = fixed_pos
	
	play("default" + ArtStyle.artstyle)
