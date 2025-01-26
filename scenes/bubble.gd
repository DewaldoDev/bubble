extends CharacterBody2D
@export var Main : Node

const pSpeed = 200.0

var isBlowing: bool

func _process(delta: float) -> void:
	if Main.gameRun:
		if isBlowing || Input.is_anything_pressed():
			velocity.y = -1 * pSpeed

		velocity += get_gravity()*delta*0.35

		if position.y < 0 || position.y > (get_window().size.y - 120):
			Main.stopGame()
		move_and_slide()

	else:
		velocity.y = 0;


func _on_main_audio_changed(db_level: Variant) -> void:
	if db_level > Main.soundThresh:
		isBlowing = true
	else:
		isBlowing = false
		
#func reset():
	#$AnimatedSprite2D.play("default")
	#
	
func pop():
	print("dead")
	$AudioManager.play_fx(0)
	$AnimatedSprite2D.play("death")
