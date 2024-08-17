extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tower_body_entered(body):
	if $Tower.level>=10:
		$Camera2D2.enabled=false
		$Camera2D3.enabled=true
	elif $Tower.level>=5:
		$Camera2D.enabled=false
		$Camera2D2.enabled=true
