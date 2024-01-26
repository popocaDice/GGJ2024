extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Scene 1".visible = true
	$"Scene 2".visible = true
	$"Scene 3".visible = true
	$"Scene 4".visible = true
	$Song.play(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if not event is InputEventMouseMotion:
		get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")


func _on_cutscene_animation_1_animation_finished(anim_name):
	$"Scene 1".queue_free()
	$"Scene 2/Scenery/Claudio".play("Idle")
	$"Scene 2/AnimationPlayer".play("pan")


func _on_claudio_animation_finished():
	$"Scene 2/Flash".visible = true
	$Woosh.play()
	await get_tree().create_timer(0.1).timeout
	$"Scene 2".queue_free()
	$Song.stop()
	$"Scene 3/AnimationPlayer".play("new_animation")
	$"Scene 3/Claudio".play("default")


func _on_claudio_isekaid_animation_finished():
	$"Scene 3".queue_free()
	$Song.play(77.60)
	$"Scene 4/AnimationPlayer".play("new_animation")
