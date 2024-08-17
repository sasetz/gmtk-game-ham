extends Node2D


@export var resource:= 10
# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel2.text=str("Resource:",resource)
	add_resource()

func add_resource():
	$add_timer.wait_time = 2.0
	$add_timer.one_shot = true
	$add_timer.autostart = true
	$add_timer.start()
	$add_timer.timeout.connect(_on_add_interval_timeout)
	
func _on_add_interval_timeout():
	resource+=1
	$RichTextLabel2.text=str("Resource:",resource)
	$add_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tower_body_entered(body):
	$add_timer.wait_time=2.0-0.1*$Tower.level
	if $Tower.level>=10:
		$Camera2D2.enabled=false
		$Camera2D3.enabled=true
	elif $Tower.level>=5:
		$Camera2D.enabled=false
		$Camera2D2.enabled=true
