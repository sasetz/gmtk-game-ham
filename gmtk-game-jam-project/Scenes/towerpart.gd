extends Node2D
class_name Tower_Part
var choosing:bool
@export var allvariants:Array
var i:=0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			choosing=false
			$Button.disabled=true
			$Button.visible=false
			

func _on_button_pressed():
	if choosing==false:
		choosing=true
	else:
		choosing=false
		$Button.disabled=true
		$Button.visible=false
