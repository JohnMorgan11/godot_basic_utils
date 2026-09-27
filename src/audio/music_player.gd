## Music Player -- Automatically plays music on loop without needing to fiddle with import properties -- uses signals that allow any node to control music playback

extends AudioStreamPlayer
class_name MusicPlayer 

signal fade_out(fade_duration : float)
signal change_stream(new_stream : AudioStream)
signal change_volume(new_volume : float, change_time : float)
signal reset() 
signal fade_out_and_change(new_stream : AudioStream, fade_duration : float, delay_time : float) 

var _original_stream : AudioStream = null
var _original_volume_db : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.bus = &"music"
	self.play() 
	
	_original_stream = self.stream
	_original_volume_db = self.volume_db
	
	self.fade_out.connect(_fade)
	self.change_stream.connect(_change)
	self.change_volume.connect(_change_volume)
	self.reset.connect(_reset)
	self.fade_out_and_change.connect(_fade_and_change)
	self.finished.connect(self.play)


func _fade(fade_duration : float) -> void:
	var tween : Tween = self.create_tween()
	
	tween.tween_property(self, "volume_db", -80.0, fade_duration)
	await tween.finished
	
	self.stop()
	self.volume_db = _original_volume_db


func _reset() -> void:
	self.stream = _original_stream
	self.volume_db = _original_volume_db
	self.play()


func _change(new_stream : AudioStream) -> void:
	self.stream = new_stream
	self.play()


func _change_volume(new_volume : float, change_time : float) -> void:
	if change_time == 0.0:
		self.volume_db = new_volume
		return
	
	var tween : Tween = self.create_tween()
	tween.tween_property(self, "volume_db", new_volume, change_time)


func _fade_and_change(new_stream : AudioStream, fade_duration : float, delay_time : float) -> void:
	_fade(fade_duration)
	
	# 0.05 is padding, because a delay_time of 0 causes the _change function to be called too soon
	delay_time = max(delay_time, 0.05)
	await get_tree().create_timer(fade_duration + delay_time).timeout
	
	_change(new_stream)
