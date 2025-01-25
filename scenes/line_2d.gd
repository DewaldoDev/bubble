extends Line2D

@export var startTexture: Texture  
@export var texture_size: float = 10.0  

#func _draw():
	#super._draw()
	#if startTexture:
		#var points = get_points()
		#if points.size() > 0:
			#draw_texture_rect(startTexture, Rect2(points[0] - Vector2(texture_size / 2, texture_size / 2), Vector2(texture_size, texture_size)))
