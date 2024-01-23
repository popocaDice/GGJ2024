extends Camera2D

@export var minLimit = Vector2.ZERO
@export var maxLimit = Vector2.ZERO

func _ready():
	set_camera_limits()

func set_camera_limits():
	#limit_left =  get_screen_center_position().x - minLimit.x
	#limit_right = get_screen_center_position().x + maxLimit.x
	#limit_top = get_screen_center_position().y - minLimit.y
	#limit_bottom = get_screen_center_position().y + maxLimit.x
	pass
