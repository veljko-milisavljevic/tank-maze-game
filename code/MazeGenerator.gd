extends Node

@export var tile_size = 32
var width = 320 / tile_size
var height = 160 / tile_size

@onready var Map = $TileMap

func _ready():
	randomize()
	Map.scale = Vector2(tile_size/4,tile_size/4)
	#Map.tile_set.set_physics_layer_collision_layer(0,1)
	make_maze()

	
func make_maze():
	var unvisited = []
	var maze = []
	Map.clear()
	#Priprema strukture podataka; 2D niz napunjen 15-icama
	for i in range(height):
		maze.append([])
		unvisited.append([])
		for j in range(width):
			unvisited[i].append(true)
			maze[i].append(15)
			Map.set_cell(0, Vector2i(j, i), 0, Vector2i(maze[i][j],0))
	
	for i in range(height):
		for j in range(width):
			var pointerNext = randi_range(0, 1)
			# 0 -> idi dole; 1 -> idi desno
			if(i == height-1):
				if(j == width-1):
					Map.set_cell(0, Vector2i(j, i), 0, Vector2i(maze[i][j],0))
				else: #Probi zid nadesno
					maze[i][j] -= 2
					maze[i][j+1] -= 8
			elif(j == width-1): #Probi zid nadole
				maze[i][j] -= 4
				maze[i+1][j] -= 1
			else: #Probi zid random
				maze[i][j] -= 4-(2*pointerNext)
				maze[i+1-pointerNext][j+pointerNext] -= 1+(7*pointerNext)
			Map.set_cell(0, Vector2i(j, i), 0, Vector2i(maze[i][j],0))





