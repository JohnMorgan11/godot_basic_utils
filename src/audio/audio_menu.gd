extends Control

var _config : ConfigFile = null

@onready var Btns : VBoxContainer = get_node("ButtonContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ExitContainer/ExitButton.pressed.connect(self.hide)
	
	_config = ConfigFile.new()
	var err : Error = _config.load("user://audio.cfg")
	
	if err != OK:
		return
	
	for i in AudioServer.get_bus_count():
		_add_volume_slider(i)


func save() -> void:
	for i in Btns.get_children():
		if i is VolumeSlider:
			i.save()
			
	_config.save("user://audio.cfg")


func _add_volume_slider(index : int) -> void:
	var volume_slider : VolumeSlider = VolumeSlider.new()
	
	volume_slider.initialize(AudioServer.get_bus_name(index), _config)
	Btns.add_child(volume_slider)


# Connected Signal Methods 


func _on_reset_button_pressed() -> void:
	for i in Btns.get_children():
		if i is VolumeSlider:
			i.reset()
