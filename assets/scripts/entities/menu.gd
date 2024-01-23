extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/iniciar.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/mundo.tscn")
	pass # Replace with function body.


func _on_sair_pressed():
	get_tree().quit()
	pass # Replace with function body.
