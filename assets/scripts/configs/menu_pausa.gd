extends Control

@onready var Menu = preload("res://assets/scenes/menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		visible = true
func _on_continuar_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false
	
func _on_menu_principal_pressed():
	get_tree().change_scene_to_file(Menu)
