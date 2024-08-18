extends MobNPC

func _ready():
	super._ready()
	if randi_range(1,3)==1:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("new_animation")
