extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$"../AnimatedSprite2D".play("Start")
	$"../Button".visible=false
	$"../Button2".visible=false
	$"../Button3".visible=false
	$"../Button5".visible=true
