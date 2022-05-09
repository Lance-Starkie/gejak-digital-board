extends Node2D

var pl_tile := preload("res://scenes/tile.tscn")
var tiles = []
var selector = null
var type_selector = 0
onready var parent := get_tree().current_scene

func _ready():
	$UI.scale = scale
	$UI.offset = position
	
func _process(delta):
	player_move_handling()
func player_move_handling():
	if Input.is_action_just_pressed("submit_move"):
		if selector != null or Input.is_action_pressed("retreat"):
			if Input.is_action_pressed("retreat"):
				parent.board.do_move(parent.board.board,[selector,0])
			elif parent.board.board[selector.x][selector.y]*parent.board.color < -1:
				parent.board.do_move(parent.board.board,[selector,parent.board.color])
			elif parent.board.board[selector.x][selector.y] != 0 or selector.x in [0,parent.board.size-1]:
				pass
			else:
				parent.board.do_move(parent.board.board,[selector,(1+type_selector)*parent.board.color])
			selector = null
			render_board(parent.board.board)
	else:
		if get_global_mouse_position() != Vector2(
			clamp(get_global_mouse_position().x,position.x,position.x+512),
			clamp(get_global_mouse_position().y,position.y,position.y+512)
			):
				if selector != null:
					$UI.deselect()
					selector = null
		else:
			if selector == null or max(
				abs(((selector+Vector2(.5,.5)) - (parent.board.size*(get_global_mouse_position()-position)/512.0)).x),
				abs(((selector+Vector2(.5,.5)) - (parent.board.size*(get_global_mouse_position()-position)/512.0)).y)
				) > .72:
				if selector != (parent.board.size*(get_global_mouse_position()-position)/512.0).floor():
					selector = (parent.board.size*(get_global_mouse_position()-position)/512.0).floor()
					if parent.board.board[min(6,selector.x)][min(6,selector.y)]*parent.board.color < -1:
						$UI.single_select(selector,int(2.5+parent.board.color*.5))
					elif parent.board.board[min(6,selector.x)][min(6,selector.y)] != 0:
						$UI.deselect()
					elif selector.x in [0,parent.board.size-1]:
						$UI.single_select(selector,1)
					else:
						if type_selector == 0:
							$UI.single_select(selector)
						else:
							$UI.full_select([[selector,true]]+parent.board.archer_stones(parent.board.board,selector,type_selector,parent.board.color))
	if Input.is_action_pressed("tile_select_1"):
		type_selector = 0
		selector = null
	elif Input.is_action_pressed("tile_select_2"):
		type_selector = 1
		selector = null
	elif Input.is_action_pressed("tile_select_3"):
		type_selector = 2
		selector = null
	elif Input.is_action_pressed("tile_select_4"):
		type_selector = 3
		selector = null
		
func render_board(board):
	clear_board()
	for file in range(board.size()):
		for rank in range(board.size()):
			if board[file][rank] != 0:
				tiles.append(pl_tile.instance())
				tiles[-1].tile = board[file][rank]
				call_deferred("add_child",tiles[-1])
				tiles[-1].to_tile(Vector2(file,rank))
			
func input_handler():
	get_global_mouse_position()
func clear_board():
	for tile in tiles:
		if tile != null:
			tile.remove_tile()
	tiles = []

func render_move():
	pass

func render_conflict():
	pass

