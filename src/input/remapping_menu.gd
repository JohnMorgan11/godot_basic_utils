extends VBoxContainer
class_name RemapMenu 

# On start-up, overwrites the input map with a dictionary sourced from a config file
# Also provides support for writing to aforementioned config file, while acting as the Menu for changing binds
# Append all user-defined actions that you wish to be rebound with a '+' sign ie -- +forward, +backward, +crouch, +sprint, +fire, etc. 

@export var BindableActions : Array[String] = []

# Dictionary that takes the form of input action string: keycode enum -> ie "pause": 16777217
var _current_binds : Dictionary = {}
var _default_binds : Dictionary = {}

# All of the bind button objects 
var _bind_buttons : Array = []

# file type isn't that important, nor is the path this can be changed later if needed
var _cfg_path : String = "user://keybinds.cfg"
var _save_config : ConfigFile = null

@onready var ButtonContainer : HBoxContainer = get_node("ButtonContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_bindable_actions()
	_create_initial_binds()
	_set_up_config()
	_add_buttons()


func _create_bindable_actions() -> void:
	for i in InputMap.get_actions():
		if i.contains("+"):
			BindableActions.push_back(str(i))


func _create_initial_binds() -> void:
	var nonexistant_actions : Array = []
	
	for i in BindableActions:
		if InputMap.get_actions().has(i):
			print_debug("Has Action: " + i)
			_default_binds[i] = InputMap.action_get_events(i)[0].get_physical_keycode()
		else:
			print_debug("Does NOT have Action: " + i)
			nonexistant_actions.push_back(i)
		
	for i : int in nonexistant_actions.size():
		print_debug("Erasing invalid actions")
		BindableActions.erase(nonexistant_actions[i])
		
	_current_binds = _default_binds.duplicate()
	
	
func _set_up_config() -> void:
	_save_config = ConfigFile.new()
	var err : Error = _save_config.load(_cfg_path)
	
	if err == ERR_FILE_NOT_FOUND:
		print_debug("Could not find keybinds.cfg, creating...")
		_write_to_config()
		_set_up_config()
	elif err != OK:
		print_debug("Could not read keybinds.cfg! Using default binds.")
		return
	
	# Prune unused elements from cfg file
	for i in _save_config.get_section_keys("custom_binds"):
		if BindableActions.has(i):
			continue
		
		print_debug("Erasing unused section key: " + i)
		_save_config.erase_section_key("custom_binds", i)
	
	_save_config.save(_cfg_path)
	
	# Load actions into binds dict 
	for i in _save_config.get_section_keys("custom_binds"):
		var keycode : int = _save_config.get_value("custom_binds", i)
		
		if str(keycode) != "":
			_current_binds[i] = keycode
		else:
			_current_binds[i] = -1
	
	_set_binds()
	

func _set_binds() -> void:
	for action: String in _current_binds.keys():
		var keycode : Key = _current_binds[action]
		InputMap.action_erase_events(action)
		
		if keycode != -1:
			var event : InputEventKey = InputEventKey.new()
			event.keycode = keycode
			InputMap.action_add_event(action, event)
		
		# Reset the text on the bind buttons in the menu
		for i in _bind_buttons.size():
			_bind_buttons[i].set_up(_current_binds.keys()[i])


func _write_to_config(overwrite : bool = false) -> void:
	for i in BindableActions:
		if !InputMap.get_actions().has(i): # Nonexistent action
			continue
		if _save_config.has_section_key("custom_binds", i) and !overwrite: # Key already exists  
			continue
		
		var keycode : Key = _current_binds[i]
		
		if keycode != -1:
			_save_config.set_value("custom_binds", i, keycode)
		else:
			_save_config.set_value("custom_binds", i, keycode)
				
	_save_config.save(_cfg_path)


func _change_bind(target_action : String, requested_keycode : Key) -> void:
	if !_current_binds.has(target_action):
		print_debug("Cannot find input action " + target_action)
		return 
	
	_current_binds[target_action] = requested_keycode
	
	# This checks for actions that have duplicate keycodes and sets them to be unassigned
	# It uses a copy of the binds dictionary with the target action erased, since the normal dictionary will return the target as a false positive
	var binds_copy : Dictionary = _current_binds.duplicate()
	binds_copy.erase(target_action)
	
	for action : String in binds_copy:
		if binds_copy[action] == requested_keycode:
			_current_binds[action] = -1
	
	_write_to_config(true)
	_set_binds()


func _add_buttons() -> void:
	for action : String in _current_binds:
		var button : RemapButton = RemapButton.new()
		var hbox : HBoxContainer = HBoxContainer.new()
		
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		hbox.add_child(button)
		self.add_child(hbox)
		
		button.set_up(action)
		_bind_buttons.append(button)
		
		button.update_keybind.connect(_change_bind)
	
	var reset_button : Button = Button.new()
	var hbox : HBoxContainer = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	hbox.add_child(reset_button)
	self.add_child(hbox)
	
	reset_button.text = "Reset"
	reset_button.pressed.connect(_on_reset_button_pressed)


func _on_reset_button_pressed() -> void:
	_current_binds.clear()
	_current_binds = _default_binds.duplicate()
	_write_to_config(true)
	_set_binds()
