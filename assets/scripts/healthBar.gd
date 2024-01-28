extends Control

var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(health):
		get_node(str("Health ", health)).texture.pause = true
		get_node(str("Health ", health)).texture.current_frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func Damage(value):
	for i in range(value):
		get_node(str("Health ", health)).texture.current_frame = 0
		get_node(str("Health ", health)).texture.pause = false
		health -= 1
