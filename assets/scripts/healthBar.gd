extends Control

var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func Damage(value):
	for i in range(value):
		get_node(str("Health ", health)).texture.current_frame = 0
		get_node(str("Health ", health)).texture.pause = false
		health -= 1
