extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Open(direction):
	$AnimatedSprite2D.flip_h = direction == 1
	$AnimatedSprite2D.play("open")
	$CollisionShape2D.queue_free()
