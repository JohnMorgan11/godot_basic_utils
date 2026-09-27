extends Button
class_name RemapButton 

signal update_keybind(action : String, keybind : int)

var _action : String = ""
var _ready_to_rebind : bool = false

func _ready() -> void:
	self.toggle_mode = true
	self.toggled.connect(_on_toggled)


func _input(event: InputEvent) -> void:
	if !self.has_focus(): 
		return 
	
	if event is InputEventKey:
		self.button_pressed = false
		self.update_keybind.emit(_action, event.keycode)
		self.set_pressed(false)
	
	elif event is InputEventMouseButton:
		if !_ready_to_rebind:
			return 
		if InputMap.action_get_events(_action).is_empty():
			return
		
		var current_bind_event : InputEventKey = InputMap.action_get_events(_action)[0]
		if current_bind_event:
			self.text = OS.get_keycode_string(current_bind_event.keycode)
		else:
			self.text = "Unassigned"
		
		_ready_to_rebind = false
		self.set_pressed(false)


func set_up(action : String) -> void:
	_action = action
	_on_toggled(false)


func _on_toggled(toggled_on : bool) -> void:
	if !_action or !InputMap.has_action(_action):
		self.text = "Nonexistent action"
		return 
	if toggled_on:
		self.text = "Press a key..."
		_ready_to_rebind = true
		return 
	if InputMap.action_get_events(_action).is_empty():
		self.text = "Unassigned"
		return 
	if !InputMap.action_get_events(_action)[0] is InputEventKey:
		self.text = "No action"
		return
	
	var event : InputEventKey = InputMap.action_get_events(_action)[0]
	self.text = _action.erase(0).capitalize() + " : " + OS.get_keycode_string(event.keycode).capitalize()
	self.release_focus()
