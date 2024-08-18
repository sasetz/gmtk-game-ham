extends MobNPC
class_name Enemy


func _ready():
	super._ready()
	TOWER_DAMAGE=15
	$AnimatedSprite2D.play("default")
