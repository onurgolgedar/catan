/// @param object

if (object_get_parent(argument[0]) == parStructure or object_get_parent(argument[0]) == parBuilding) {
	global.addStructure_mode = true
	global.addStructure_object = argument[0]
}