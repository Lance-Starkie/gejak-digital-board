extends Node2D
var tile
var tile_location: Vector2
var color
var type

func _ready():
	pass
	
func stack(location):
	pass
	
func to_tile(location):
	color = int(tile < 0)
	$tile_base.frame = color
	if tile < 0:
		rotation_degrees = 180
		$tile_base.flip_h = true
	else:
		rotation_degrees = 0
		$tile_base.flip_h = false
	$overlay.frame = [3,2,4,1,5,0,4,2,3][tile+4]
	position = (location*2 + Vector2(1,1))*200
	
func remove_tile():
	call_deferred('free')
