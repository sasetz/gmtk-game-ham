extends Node2D
class_name menu
var back:AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.Scene=="End" or Global.Scene=="Death":
		$Button.visible=false
		$Button2.visible=false
		$Button3.visible=false
	if Global.Scene=="End":
		$Button5.visible=true
	$AnimatedSprite2D.play(Global.Scene)
	
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_2_pressed():
	$ColorRect.visible=true


func _on_button_3_pressed():
	$Credits.visible=true


func _on_animated_sprite_2d_animation_finished():
	if Global.Scene=="Menu":
		get_tree().change_scene_to_file("res://main.tscn")
	elif Global.Scene=="End":
		$AnimatedSprite2D.play("Menu")
		Global.Scene="Menu"
		$Credits.visible=true
	elif  Global.Scene=="Death":
		$Button4.visible=true
		
		
	pass # Replace with function body.


func _on_button_4_pressed():
	$Button4.visible=false
	$AnimatedSprite2D.play("Menu")
	Global.Scene="Menu"
	$Button.visible=true
	$Button2.visible=true
	$Button3.visible=true


func _on_button_5_pressed():
	if Global.Scene=="Menu":
		get_tree().change_scene_to_file("res://main.tscn")
	elif Global.Scene=="End":
		$AnimatedSprite2D.play("Menu")
		Global.Scene="Menu"
		$Credits.visible=true
		$Button.visible=true
		$Button2.visible=true
		$Button3.visible=true
	$Button5.visible=false
