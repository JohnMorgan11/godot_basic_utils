extends HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = MouseSens.get_mouse_sens_mod() * 100
	self.value_changed.connect(_on_value_changed)


func _on_value_changed(value : float) -> void:
	MouseSens.set_mouse_sens(ratio)
