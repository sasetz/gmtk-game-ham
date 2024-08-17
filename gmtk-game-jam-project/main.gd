extends Node2D


@export var resource:= 10
var _resource_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	$ResourceLabel.text = str("Resource:",resource)
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
	resource+=1
	$ResourceLabel.text = str("Resource:", resource)
	_resource_timer.start()


func _on_tower_body_entered(_body):
	_resource_timer.wait_time = 2.0 - 0.1 * $Tower.level
	if $Tower.level >= 10:
		$GameManager/HealthLabel.position=Vector2(850,-950)
		$ResourceLabel.position=Vector2(-950,-950)
		$GameManager/Spawner.position.x=-1000
		$GameManager/Spawner2.position.x=1000
		$Camera2D2.enabled=false
		$Camera2D3.enabled=true
	elif $Tower.level>=5:
		$GameManager/HealthLabel.position=Vector2(655,-800)
		$ResourceLabel.position=Vector2(-760,-800)
		$GameManager/Spawner.position.x=-825
		$GameManager/Spawner2.position.x=825
		$Camera2D.enabled=false
		$Camera2D2.enabled=true
