extends CanvasLayer

@export_file_path("*.tscn") var StartingScene : String = ""

@onready var AudioMenu : Control = get_node("AudioMenu")
@onready var ControlsMenu : Control = get_node("ControlMenu")

func _ready() -> void:
	AudioMenu.hide()
	ControlsMenu.hide()
	$ButtonContainer/ControlsContainer/ControlsButton.pressed.connect(ControlsMenu.show)
	$ButtonContainer/AudioContainer/AudioButton.pressed.connect(AudioMenu.show)
	$ButtonContainer/StartContainer/StartButton.pressed.connect(SceneTransition.change_scene.bind(StartingScene))
