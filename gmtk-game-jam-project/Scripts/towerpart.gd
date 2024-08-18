extends Node2D
class_name Tower_Part
var choosing:bool
@export var allvariants:Array
var i:=0

var tower: Tower 
# Called when the node enters the scene tree for the first time.
func _ready():
	tower= get_parent() as Tower
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if choosing==true:
		if Input.is_action_just_released("MWU"):
			i=i+1
			if i>len(allvariants)-1:
				i=0
			$Sprite2D.texture=allvariants[i]
		if Input.is_action_just_released("MWD"):
			i=i-1
			if i<0:
				i=len(allvariants)-1
			$Sprite2D.texture=allvariants[i]
		if Input.is_action_just_pressed("mouse1"):
			_end()
			

func _on_button_pressed():
	if choosing==false:
		choosing=true
	else:
		_end()
		
func _end():
	match i:
		3:
			tower.INCOME_TIME-=0.2
			print(tower.INCOME_TIME)
		4:
			tower.REGENERATION+=0.5
	choosing=false
	$Button.disabled=true
	$Button.visible=false
