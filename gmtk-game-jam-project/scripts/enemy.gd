extends MobNPC
class_name Enemy


func _ready():
	super._ready()
	
	$AnimatedSprite2D.play("default")
