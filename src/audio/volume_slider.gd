class_name VolumeSlider
extends VBoxContainer

var _bus : String = ""
var _config : ConfigFile 
var _heading_label : Label = null
var _slider : HSlider = null
var _preview_player : AudioStreamPlayer = null

func initialize(bus : String, config : ConfigFile) -> void:
	_bus = bus
	_config = config
	
	_create_heading_label()
	_create_and_set_slider()
	_create_audio_stream_player()
	
	_slider.value_changed.connect(_on_value_changed)
	_slider.drag_ended.connect(_on_drag_ended)


func _create_heading_label() -> void:
	_heading_label = Label.new()
	add_child(_heading_label)
	_heading_label.text = _user_friendly_label_string()


func _create_and_set_slider() -> void:
	_slider = HSlider.new()
	add_child(_slider)
	_slider.value = _config.get_value("volume", _bus, 100.0)


func reset() -> void:
	_slider.value = 50.0


func save() -> void:
	_config.set_value("volume", _bus, float(_slider.value))


func _user_friendly_label_string() -> String:
	match _bus:
		"Master":
			return "Master Volume"
		"music":
			return "Music"
		"sfx":
			return "Sound Effects"
		"character":
			return "Character Voices"
		_:
			return "Invalid Audio Bus"


func _create_audio_stream_player() -> void:
	match _bus:
		"sfx":
			var stream : AudioStream = load("res://snd/sfx/test.wav")
			_preview_player = Audio.create_audio_stream_player(self, "sfx", stream)
		"character":
			var stream : AudioStream = load("res://snd/characters/test.wav")
			_preview_player = Audio.create_audio_stream_player(self, "character", stream)


# Connected Signal Methods 


func _on_drag_ended(value_changed : bool) -> void:
	if _preview_player:
		_preview_player.play()
	
	Audio.save_audio_volume(_bus, _slider.value)


func _on_value_changed(value : float) -> void:
	Audio.set_audio_bus_volume(_bus, value / 100.0)
