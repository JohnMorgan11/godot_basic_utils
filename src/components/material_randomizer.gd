## Overwrites the material with one of a selected suite of possible materials 

extends Node

@export var Targets : Array[MeshInstance3D] = [] ## The mesh or meshes that'll have their material overriden
@export var Materials : Array[Material] = [] ## All possible materials that the mesh can have

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Targets.is_empty():
		return
	if Materials.is_empty():
		return
	
	var selected_material : Material = Materials.pick_random()
	
	for i : MeshInstance3D in Targets:
		if is_instance_valid(i):
			i.set("material_override", selected_material)


func randomize_material(target : MeshInstance3D) -> void:
	var selected_material : Material = Materials.pick_random()
	target.set("material_override", selected_material)
