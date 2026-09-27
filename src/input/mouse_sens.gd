extends Node

var mouse_sens_mod : float = 1.0

func _ready() -> void:
	_load_mouse_sens()


func get_mouse_sens_mod() -> float:
	return mouse_sens_mod


func set_mouse_sens(ratio : float) -> void:
	var padding : float = 0.1
	mouse_sens_mod = ratio + padding
	
	var mouse_config : ConfigFile = ConfigFile.new()
	var mouse_path : String = "user://mouse.cfg"
	var err : Error = mouse_config.load(mouse_path)
	
	if err != OK:
		return 
	
	mouse_sens_mod = ratio
	mouse_config.set_value("main", "sens", ratio)
	mouse_config.save(mouse_path)


func _load_mouse_sens() -> void:
	var mouse_config : ConfigFile = ConfigFile.new()
	var mouse_path : String = "user://mouse.cfg"
	var err : Error = mouse_config.load(mouse_path)
	
	if err == ERR_FILE_NOT_FOUND:
		_create_default_mouse_cfg(mouse_config, mouse_path)
	elif err != OK:
		return 
	
	set_mouse_sens(mouse_config.get_value("main", "sens", 1.0))


func _create_default_mouse_cfg(config : ConfigFile, path : String) -> void:
	print_debug("mouse.cfg not found, creating default mouse config")
	
	config.set_value("main", "sens", 0.8)
	config.save(path)
	
	_load_mouse_sens()
