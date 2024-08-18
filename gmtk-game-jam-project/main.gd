extends Node2D


@export var resource := 10
@export var game_end: PackedScene = preload("res://Scenes/UI/Game_end.tscn")
@export var left_spawner: Marker2D
@export var right_spawner: Marker2D
@export var health_label: RichTextLabel
@export var resource_label: RichTextLabel
@export var first_camera: Camera2D
@export var second_camera: Camera2D
@export var third_camera: Camera2D

var LIFE_TIME_MODIFICATOR:=1.0
var _resource_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	resource_label.text = str("Resource:", resource)
	health_label.text = str("Health:",$Tower.health)
	add_resource()

func add_resource():
	_resource_timer = Timer.new()
	_resource_timer.wait_time = 2.0
	_resource_timer.one_shot = true
	_resource_timer.autostart = true
	_resource_timer.start()
	_resource_timer.timeout.connect(_on_add_interval_timeout)
	add_child(_resource_timer)
	
func _on_add_interval_timeout():
	resource += 1
	resource_label.text = str("Resource:", resource)
	_resource_timer.start()


func _on_tower_body_entered(_body):
	_resource_timer.wait_time = 2.0 - 0.1 * $Tower.level
	health_label.text = str("Health:", $Tower.health)
	if $Tower.health<=0:
		var obj : Control = game_end.instantiate()
		add_child(obj)
		get_tree().paused = true
	if $Tower.level >= 10:
		health_label.position = Vector2(850,-950)
		resource_label.position = Vector2(-950,-950)
		left_spawner.position.x = -1000
		right_spawner.position.x = 1000
		second_camera.enabled = false
		third_camera.enabled = true
		LIFE_TIME_MODIFICATOR=2.0
	elif $Tower.level >= 5:
		health_label.position = Vector2(655,-800)
		resource_label.position = Vector2(-760,-800)
		left_spawner.position.x = -825
		right_spawner.position.x = 825
		first_camera.enabled = false
		second_camera.enabled = true
		LIFE_TIME_MODIFICATOR=1.5
