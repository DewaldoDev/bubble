extends CharacterBody2D
@export var Main : Node

const pSpeed = 200.0
@onready var line = %Line2D
const lSpeed = 2.0 
const xThresh = -100

func _physics_process(delta: float) -> void:
	if Main.gameRun:
		var direction := Input.get_axis("ui_up", "ui_down")
		if direction:
			velocity.y = direction * pSpeed
		else: 
			velocity.y = 0;
		if position.y < 0 || position.y > get_window().size.y:
			$Main.stopGame()
			
		
	move_and_slide()
