extends CharacterBody2D
@export var Main : Node

const pSpeed = 200.0
@onready var line = %Line2D
const lSpeed = 2.0 
const xThresh = -100

var isBlowing: bool

func _physics_process(delta: float) -> void:
	if Main.gameRun:
		if isBlowing:
			velocity.y = -1 * pSpeed

		velocity += get_gravity()*delta*0.5

		if position.y < 0 || position.y > get_window().size.y:
			Main.stopGame()
			
		
	move_and_slide()


func _on_main_audio_changed(db_level: Variant) -> void:
	if db_level > -20:
		isBlowing = true
	else:
		isBlowing = false
