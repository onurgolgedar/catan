//draw_text(x, y, string(index))

if (isActive and point_distance(x, y, mouse_x, mouse_y) < 30) {
	draw_set_alpha(0.4)
		for (var i = 0; i < ds_list_size(adjacentLocations); i++) {
			var location = ds_list_find_value(adjacentLocations, i)
		
			if (location.isActive) {
				draw_set_color(c_aqua)
					draw_line_width(x, y, location.x, location.y, 4)
					draw_circle(location.x, location.y, 3, 0)
				draw_set_color(c_default)
			}
		}
	draw_set_alpha(1)
	
	draw_set_color(c_aqua) draw_set_alpha(0.3)
		draw_circle(x, y, 5, 0)
	draw_set_color(c_default) draw_set_alpha(1)
}