extends Node

var parent
var size
var color = -1
var board

func _init(parent_in,size_in):
	parent = parent_in
	size = size_in
	board = []
	var place
	var tile
	var outline = ""
	for file in range(size):
		board.append([])
		for rank in range(size):
			board[file].append(0)
	parent.get_node("Board").render_board(board)
	
func update_tile(board,location,archer):
	board[location.x][location.y] = archer
	var dump = clear_column(board[location.x])
	board[location.x] = dump[0]
	if dump[1] > 0:
		if board[location.x][location.y] == 0:
			if abs(archer) == 1:
				board[location.x][location.y] = [-1,archer,1][int(clamp((location.y-floor(size/2.0))*2,-1,1))+1]
			else:
				board[location.x][location.y] = archer
		board[location.x] = clear_column(board[location.x])[0]
	
	
func archer_stones(board,location,archer,color):
	var out_locations := []
	var vectors = [
	[],
	[Vector2(-1,0),     Vector2(1,0)],
	[Vector2(-1,color), Vector2(1,color)],
	[Vector2(-1,-color),Vector2(1,-color)]
	][archer]
	
	for vector in vectors:
		out_locations.append(line_of_sight(board,location,vector,color))
		
	return out_locations
	
func do_move(board,move):
	if end_check(board):
		print("end")
	else:
		var tile = move[0]
		var archer = move[1]
		if archer == 0:
			var complete = false
			for file in range(board.size()-2):
				for rank in range(board.size()):
					if board[file+1][rank]*-color > 1:
						print("bonk")
						update_tile(board,Vector2(file+1,rank),0)
						complete = true
			if complete:
				color*=-1
			else:
				print("no archers found")
		elif board[move[0].x][move[0].y] == 0:
			for location in archer_stones(board,tile,abs(archer)-1,clamp(archer,-1,1)):
				if location[1]:
					update_tile(board,location[0],-clamp(archer,-1,1))
			update_tile(board,tile,-archer)
			color*=-1
		elif board[move[0].x][move[0].y]*move[1] == -abs(board[move[0].x][move[0].y]) and abs(board[move[0].x][move[0].y]) > 1:
			update_tile(board,tile,-clamp(archer,-1,1))
			color*=-1
		
func end_check(board):
	var locked_counts = [0,0]
	var full = board.size()-2

	for col in board.slice(1,-1):
		if col.count(0) > 1: full-=1
		if not 0 in col:
			for tile in col:
				locked_counts[0] += int(tile < 0)
				locked_counts[1] += int(tile > 0)

	if not 0 in board[1] or board[2]:
		for tile in board[1]:
			locked_counts[0] += int(tile < 0)
			locked_counts[1] += int(tile > 0)

	if not 0 in board[-1] or board[-2]:
		for tile in board[-1]:
			locked_counts[0] += int(tile < 0)
			locked_counts[1] += int(tile > 0)


	if max(locked_counts[0],locked_counts[1])>int((pow(board.size(),2))/2.0):
		return true

	if full >= board.size()-2-round(board.size()/4.0):

		return true

	return false
	
#Utilities

func line_of_sight(board,location,vector,color):
	#Return location of last occurance of an empty square before first non-empty square starting from the first empty square.
	var begun := false
	var tile : int
	var output_tile = location
	var place_tile := false
	
	for mult in range(1,min(#Determines maximum length to edge
			[INF,fposmod(((location.x+1)*-vector.x),board.size()+1)][abs(vector.x)],
			[INF,fposmod(((location.y+1)*-vector.y),board.size()+1)][abs(vector.y)]
			)):
		tile = board[(mult*vector + location).x][(mult*vector + location).y]
		begun = begun or tile*color >= 0
		if begun and tile != 0:
			break
		place_tile = begun
		output_tile = mult*vector + location
	return [output_tile,place_tile]

#Conflict Handlers

func mark_column(column, conflict_out = false):
	var chunks = [[]]

	for tile in [-1]+column+[1]:
		if tile == 0 or 0 in chunks[-1]:
			chunks.append([tile])
		else:
			chunks[-1].append(tile)

	var tile_row = -1
	var clear = []
	var old
	var conflict
	var start
	
	for chunk in chunks:
		old = 0
		conflict = 0
		start = tile_row + 1

		for tile in chunk:
			tile_row += 1
			if tile*INF!=old:
				conflict += 1
			old = tile*INF
		if conflict > 2:
			clear = clear + Array(range(start,tile_row-1))

	return clear

func clear_column(column):
	var counts = [0,0]
	var clear
	for tile in column:
		counts[0] += int(tile > 0)
		counts[1] += int(tile < 0)
		
	if not 0 in counts:
		clear = mark_column(column)
		
	else:
		
		return([column,0])
		
	var decount = 0
	
	if len(clear) == 0:
		
		return ([column,0])
		
	for tile in clear:
		column[tile] = 0
		decount += 1
		
	return ([column,decount])
