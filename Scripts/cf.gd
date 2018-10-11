extends Node

## CONVENIENCE FUNCTIONS

func id_to_grid(id,grid_size,columns):
	# turns an id into a region on an icon sheet
	# grid_size is how large the grid is in pixels
	# columns is how many columns the file containers
	var y_pos = floor(id/columns)
	var x_pos = id - (y_pos*columns)
	
	return Rect2(x_pos * grid_size,y_pos * grid_size,grid_size,grid_size)