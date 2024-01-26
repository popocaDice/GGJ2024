extends HSlider
@onready var test_sound = $"../TestSound"

@export
var bus_name: String

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value  = db_to_linear(
	 	AudioServer.get_bus_volume_db(bus_index)
	)
func _on_value_changed(value: float ) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)


func _on_testar_sfx_pressed():
	test_sound.play()


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")
