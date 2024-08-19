extends "res://addons/ProjectileOnCurve2DPlugin/ProjectileOnCurve2D.gd"
class_name MeteorOnCurve2D

func _ready():
	$AnimatedSprite2D.play("default")
