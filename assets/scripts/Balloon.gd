extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.velocity.y = 0
		$Jingle.play()
		$Sprite2D.queue_free()
		Engine.time_scale = 0.05
		Engine.physics_ticks_per_second = 5
		body.hasBaloon = true
		await get_tree().create_timer(0.15).timeout
		Engine.physics_ticks_per_second = 60
		Engine.time_scale = 1
		queue_free()
