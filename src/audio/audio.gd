extends Node

enum StreamType {ENV_2D, ENV_3D, GEN}

func _ready() -> void:
	_load_audio_buses()


# Creates an audio stream player 
func create_audio_stream_player(parent : Node, bus : String, stream : AudioStream, type : StreamType = StreamType.GEN) -> AudioStreamPlayer:
	if !is_instance_valid(stream):
		return null 
	
	var result : Node
	
	match type:
		StreamType.GEN:
			result = AudioStreamPlayer.new()
		StreamType.ENV_2D:
			result = AudioStreamPlayer2D.new()
		StreamType.ENV_3D:
			result = AudioStreamPlayer3D.new()
	
	parent.add_child(result)
	
	result.stream = stream
	result.bus = bus
	
	return result


# Self explainatory
func set_audio_bus_volume(bus : String, value : float) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus)
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)


func save_audio_volume(bus : String, amount : int) -> void:
	var audio_config : ConfigFile = ConfigFile.new()
	var audio_path : String = "user://audio.cfg"
	var err : Error = audio_config.load(audio_path)
	
	if err != OK:
		return 
	
	audio_config.set_value("volume", bus, amount)
	audio_config.save(audio_path)


func _load_audio_buses() -> void:
	var audio_config : ConfigFile = ConfigFile.new()
	var audio_path : String = "user://audio.cfg"
	var err : Error = audio_config.load(audio_path)
	
	if err == ERR_FILE_NOT_FOUND:
		_create_default_audio_cfg(audio_config, audio_path)
	elif err != OK:
		return
	
	for i in audio_config.get_section_keys("volume"):
		set_audio_bus_volume(i, audio_config.get_value("volume", i, 0.0) / 100.0)


func _create_default_audio_cfg(config : ConfigFile, path : String) -> void:
	print_debug("audio.cfg not found, creating default audio config")
	
	for i in AudioServer.get_bus_count():
		config.set_value("volume", AudioServer.get_bus_name(i), 50)
	
	config.save(path)
	_load_audio_buses()
