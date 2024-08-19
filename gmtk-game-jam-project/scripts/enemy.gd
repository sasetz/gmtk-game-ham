extends MobNPC
class_name Enemy


@export var ZombifiedFriendScene = preload("res://Scenes/Enemies/enemy.tscn")

func _ready():
	super._ready()
	TOWER_DAMAGE=15
	LIFE_TIME=10
	self.VERTICALSPEED = 100
	self.SPEED=100
	$AnimatedSprite2D.play("default")

func _on_mob_collided(entity: Node2D):
	if not entity.is_in_group("friend"):
		return
	var mob = entity as MobNPC
	if true or weath.type == "Moon":
		var new_enemy = ZombifiedFriendScene.instantiate()
		new_enemy.position = mob.position
		new_enemy.DIRECTION = mob.DIRECTION
		new_enemy.scale.x = mob.scale.x
		print("zonbufied")
		get_tree().current_scene.add_child(new_enemy)
		mob.die()
