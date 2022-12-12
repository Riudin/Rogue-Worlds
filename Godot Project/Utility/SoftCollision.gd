extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0 #return true for the function if areas is more than 1
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]  #selects only the first area, makes things simpler
		push_vector = area.global_position.direction_to(global_position)
	return push_vector
