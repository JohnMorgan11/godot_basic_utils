extends Node

enum {AUTOSTART, STOPPED}

# Creates and connects a Timer node to the parent parameter 
# Useful for quickly creating a timer in code 
func create_timer(parent : Node, method : Callable, wait_time : float, one_shot : bool = true, start : int = STOPPED) -> Timer:
	var timer : Timer = Timer.new()
	
	parent.add_child(timer)
	timer.timeout.connect(method)
	timer.set_one_shot(one_shot)
	timer.set_wait_time(wait_time)
	
	if start == AUTOSTART:
		timer.start()
	
	return timer


# Returns the nearest multiplier of the multiple parameter 
# ie - input = 27; multiple = 5; result = 25
func nearest_mult(input : float, multiple : float) -> int: 
	if multiple > input:
		return multiple
	
	return (input - (fmod(input, multiple))) as int


func clear_invalid_instances_from_array(target : Array) -> Array:
	var result : Array = []
	
	for i : int in target.size():
		if is_instance_valid(target[i]):
			result.push_back(i)
	
	return result


func do_arrays_match(x : Array, y : Array) -> bool:
	if x.size() != y.size():
		return false
	
	for i : int in x.size():
		if !y.has(x[i]):
			return false
		if y.count(x[i]) != x.count(x[i]):
			return false
	
	return true
