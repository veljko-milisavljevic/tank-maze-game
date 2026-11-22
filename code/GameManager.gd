extends Node

@onready var label_1 = $Score1
@onready var label_2 = $Score2

func _ready():
	label_1.text = "Player 1: " + str(Global.score1)
	label_2.text = "Player 2: " + str(Global.score2)

func score_1():
	Global.score1 += 1
	print("Player 1: " + str(Global.score1))
	
func score_2():
	Global.score2 += 1
	print("Player 2: " + str(Global.score2))

