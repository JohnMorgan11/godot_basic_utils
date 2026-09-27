extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ExitContainer/ExitButton.pressed.connect(self.hide)
