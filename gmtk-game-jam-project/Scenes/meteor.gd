
extends Area2D
class_name MeteorOnCurve2D
var TOWER_DAMAGE:=50

	
const _speed = 100
var _gravity: float
var _velocity: Vector2
var _stepAmount: int
var boom:=false
func _ready():
	$AnimatedSprite2D.play("default")	

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
	$Area2D/CollisionShape2D2.disabled=false
	_on_area_2d_body_entered(bod)
	for body in get_overlapping_bodies():
		if (body is MobNPC):
			body.queue_free()
		elif (body is BuildingStructure):
			body.current_health-=(TOWER_DAMAGE/2)
			var perc:float=body.current_health/body.INITIAL_HEALTH
			if perc>=0.7:
				body.sprite.texture=body.Structure_vatiation[0]
			elif perc>=0.4:
				body.sprite.texture=body.Structure_vatiation[1]
			elif perc>0.0:
				body.sprite.texture=body.Structure_vatiation[2]


func _on_area_2d_body_entered(bod):
	for body in get_overlapping_bodies():
		if (body is MobNPC):
			body.queue_free()
		elif (body is BuildingStructure):
			body.current_health-=(TOWER_DAMAGE/2)
			var perc:float=body.current_health/body.INITIAL_HEALTH
			if perc>=0.7:
				body.sprite.texture=body.Structure_vatiation[0]
			elif perc>=0.4:
				body.sprite.texture=body.Structure_vatiation[1]
			elif perc>0.0:
				body.sprite.texture=body.Structure_vatiation[2]
	$".".queue_free()
