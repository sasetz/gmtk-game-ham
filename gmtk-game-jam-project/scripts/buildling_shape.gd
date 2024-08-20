extends RigidBody2D
class_name BuildingStructure


@export var INITIAL_HEALTH := 30.0
@export var Structure_vatiation: Array

@onready var animplayer:AnimatedSprite2D=$Node2D/AnimatedSprite2D

var current_health := INITIAL_HEALTH:
	set(value):
		if value <= 0:
			has_collision = false
			animplayer.visible = true
			animplayer.play("default")
			$Node2D/AudioStreamPlayer.play()
		current_health = value

var has_collision := true :
	set(value):
		call_deferred("set_freeze_enabled", not value)
		call_deferred("set_sleeping", not value)
		if Collision:
			Collision.call_deferred("set_disabled", not value)

		has_collision = value

@onready var Collision = $Collision
@onready var sprite = $Node2D/Sprite2D

func _ready() -> void:
	Collision.disabled = not has_collision
	freeze = not has_collision
	animplayer.animation_finished.connect(queue_free)
	current_health = INITIAL_HEALTH


func rotate_physically(radians: float):
	var target = Vector2.from_angle(rotation + radians)
	look_at(global_position + target)
	
