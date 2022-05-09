extends Node2D

var Board = preload("res://scenes/main_scene/board_state.gd")
onready var parent := get_tree().current_scene
var board

func _ready():
	board = Board.new(parent,7)
	
