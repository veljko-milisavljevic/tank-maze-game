extends Container

@onready var rightBorder = $Right/CollisionShape2D
@onready var bottomBorder = $Bottom/CollisionShape2D

	
func _on_viewport_size_changed():
	# Do whatever you need to do when the window changes!
	print ("Viewport size changed")
