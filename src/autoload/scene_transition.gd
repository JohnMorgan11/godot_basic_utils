extends CanvasLayer

# An overlay used for transitioning scenes 
enum Fade {IN, OUT}

@onready var Overlay : ColorRect = get_node("ScreenOverlay")
@onready var AnimPlayer : AnimationPlayer = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	Overlay.hide()


func change_scene(scene : String) -> void:
	_fade_transition(scene)


func fade_screen(in_or_out : Fade, speed_scale : float = 1.0) -> void:
	AnimPlayer.speed_scale = speed_scale
	
	Overlay.show()
	
	if in_or_out == Fade.OUT:
		AnimPlayer.play("fade")
	else:
		AnimPlayer.play_backwards("fade")
		
	await AnimPlayer.animation_finished
	
	Overlay.hide()
	
	AnimPlayer.speed_scale = 1.0


func _fade_transition(scene : String) -> void:
	Overlay.show()
	
	AnimPlayer.play("fade")
	await AnimPlayer.animation_finished
	
	get_tree().change_scene_to_file(scene)
	
	AnimPlayer.play_backwards("fade")
	await AnimPlayer.animation_finished 
	
	Overlay.hide()
