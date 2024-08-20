
extends Area2D
class_name MeteorOnCurve2D
var TOWER_DAMAGE:=50

	
const _speed = 100
var _gravity: float
var _velocity: Vector2
var _stepAmount: int

@onready var _explode_anim: AnimatedSprite2D = $ExplosionAnimatedSprite

func _ready():
	$AnimatedSprite2D.play("default")	
	_explode_anim.animation_finished.connect(queue_free)

func launch(startPos: Vector2, targetPos: Vector2, grav: float, stepAmount: int = 1) -> void:
	_gravity = grav
	_stepAmount = stepAmount

	var distance = targetPos - startPos
	var time = distance.length() / _speed
	_velocity = distance / time + Vector2(0, -_gravity * time / 2)
	position = startPos
	rotation = _velocity.angle()


func _physics_process(delta):
	for i in range(_stepAmount):
		_velocity.y += _gravity * delta
		position += _velocity * delta
	rotation = _velocity.angle()
	



func _on_body_entered(bod):
	$Area2D/CollisionShape2D2.call_deferred("set_disabled", false)
	_on_area_2d_body_entered(bod)
	for body in get_overlapping_bodies():
		if (body is MobNPC):
			body.die()
		elif (body is BuildingStructure):
			body.current_health -= int(TOWER_DAMAGE / 2.0)
			var perc:float=body.current_health/body.INITIAL_HEALTH
			if perc>=0.7:
				body.sprite.texture=body.Structure_vatiation[0]
			elif perc>=0.4:
				body.sprite.texture=body.Structure_vatiation[1]
			elif perc>0.0:
				body.sprite.texture=body.Structure_vatiation[2]


func _on_area_2d_body_entered(_bod):
	for body in get_overlapping_bodies():
		if (body is MobNPC):
			body.die()
		elif (body is BuildingStructure):
			body.current_health -= int(TOWER_DAMAGE / 2.0)
			var perc:float=body.current_health/body.INITIAL_HEALTH
			if perc>=0.7:
				body.sprite.texture=body.Structure_vatiation[0]
			elif perc>=0.4:
				body.sprite.texture=body.Structure_vatiation[1]
			elif perc>0.0:
				body.sprite.texture=body.Structure_vatiation[2]
	collision_mask = 0
	collision_layer = 0
	$AnimatedSprite2D.call_deferred("set_visible", false)
	_explode_anim.call_deferred("set_visible", true)
	_explode_anim.play("explosion")
	_velocity = Vector2.RIGHT # turn the animation the right way
	_stepAmount = 0
