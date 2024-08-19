extends MobNPC
class_name Enemy


@export var ZombifiedFriendScene = preload("res://Scenes/enemy.tscn")

func _ready():
	super._ready()
	TOWER_DAMAGE=15
	LIFE_TIME=10
	self.VERTICALSPEED = 100
	self.SPEED=100
	$AnimatedSprite2D.play("default")
	on_mob_collision.connect(_on_mob_collided)

func _on_mob_collided(mob: MobNPC):
	if weath.type == "Moon":
		var new_enemy = ZombifiedFriendScene.instantiate()
		new_enemy.position = mob.position
		new_enemy.DIRECTION = mob.DIRECTION
		new_enemy.scale.x = mob.scale.x
		print("zonbufied")
		get_tree().current_scene.add_child(new_enemy)
		mob.queue_free()
