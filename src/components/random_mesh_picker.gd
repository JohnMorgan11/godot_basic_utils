extends Node

## Picks a random mesh from a list of possible meshes, showing that mesh and hiding the rest 
## Stores a reference to the selected mesh that can be used by other scripts

@export var Meshes : Array[MeshInstance3D] = [] ## Possible meshes to be picked, all non-picked meshes will be hidden
@export var DeleteNonselected : bool = false ## If set to true, deletes all non-selected meshes

var _selected_mesh : MeshInstance3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Meshes.is_empty():
		return 
	
	_selected_mesh = Meshes.pick_random()
	_selected_mesh.show()
	
	for i : MeshInstance3D in Meshes:
		if i == _selected_mesh:
			continue

		i.queue_free() if DeleteNonselected else i.hide()


func get_mesh_array() -> Array[MeshInstance3D]:
	return Meshes


func get_mesh() -> MeshInstance3D:
	return _selected_mesh
