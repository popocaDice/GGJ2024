extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if not event is InputEventMouseMotion:
		get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")
