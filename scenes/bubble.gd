extends CharacterBody2D
@export var Main : Node

const pSpeed = 200.0
@onready var line = %Line2D
const lSpeed = 2.0 
const xThresh = -100

var isBlowing: bool

func _physics_process(delta: float) -> void:
	if Main.gameRun:
		if isBlowing || Input.get_axis("ui_up", "ui_down"):
			velocity.y = -1 * pSpeed

		velocity += get_gravity()*delta*0.4

		if position.y < 0 || position.y > get_window().size.y:
			Main.stopGame()
			
	else:
		velocity.y = 0;
	move_and_slide()


func _on_main_audio_changed(db_level: Variant) -> void:
	if db_level > -20:
		isBlowing = true
	else:
		isBlowing = false

func pop():
	$AnimatedSprite2D.play("death")
