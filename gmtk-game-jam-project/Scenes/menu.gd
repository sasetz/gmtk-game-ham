extends Node2D
class_name menu
var back:AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play(Global.Scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
