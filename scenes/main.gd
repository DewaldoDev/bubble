extends Node

var pipeScene = [preload("res://scenes/obsticles/brick and spike.tscn"), preload("res://scenes/obsticles/lamp_obsticle.tscn"), preload("res://scenes/obsticles/no_bubbles_obsticle.tscn"), preload("res://scenes/obsticles/pillers.tscn")]

signal audio_changed(db_level)

var gameRun : bool

var startWaiting : bool
const scaleAdd : Vector2 = Vector2(0.02, 0.02)

var score
var scroll
var pipes : Array
const pipeDelay : int = 100
const pipeRange : int = 150
var screen_size : Vector2i
const soundThresh: int = -20


var pipeGap : int = 200
var scrollSpeed : float = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	newGame()

func newGame():
	startWaiting = true
	gameRun = false
	score = 0
	scroll = 0
	pipeGap = 200
	scrollSpeed = 2
	pipes.clear()
	pipes.append($Wand)
	_on_timer_timeout()
	
func startGame():
	startWaiting = false
	gameRun = true;
	$Timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var db_level = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Capture"), 0)
	audio_changed.emit(db_level)
	if gameRun:
		scroll += scrollSpeed
		if scroll>=screen_size.x:
			scroll=0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= scrollSpeed
	else: 
		if startWaiting:
			if db_level > soundThresh || Input.is_anything_pressed():
				$bubble.scale += scaleAdd
				if($bubble.scale.x >= 1):
					$bubble.scale = Vector2(1,1)
					$bubble.position.x = 120
					startGame()
			else:
				$bubble.scale -= scaleAdd
				if($bubble.scale.x < 0):
					$bubble.scale  =Vector2(0,0)
					
		#else:
			#if db_level > soundThresh+10:
				#get_tree().reload_current_scene()

	

	

func _on_timer_timeout() -> void:
	var ind = randi_range(0, pipeScene.size()-1)
	var pipeObj1 = pipeScene[ind].instantiate()
	var pipeObj2 = pipeScene[ind].instantiate()
	
	pipeObj1.scale = Vector2(2,2)
	pipeObj2.scale = Vector2(2,-2)
	
	pipeObj1.position.x = screen_size.x + pipeDelay
	pipeObj2.position.x = screen_size.x + pipeDelay

	pipeObj1.position.y = (screen_size.y) / 1.8 + randi_range(-pipeRange, pipeRange)
	pipeObj2.position.y = pipeObj1.position.y - pipeGap;

	pipeObj1.hit.connect(stopGame)
	pipeObj2.hit.connect(stopGame)

	pipeObj1.scored.connect(scoreIncrement)
	
	add_child(pipeObj1)
	add_child(pipeObj2)
	pipes.append(pipeObj1)
	pipes.append(pipeObj2)

func stopGame():
	gameRun=false
	$Timer.stop()
	$bubble.pop()

func scoreIncrement(): # scrollSpeed, pipeGap, timer
	score+=1
	$AudioManager.play_fx(1)

	if score == 2:
		scrollSpeed=3
		$Timer.wait_time=3
	elif score == 5:
		scrollSpeed=4
		$Timer.wait_time=2.8
	elif score == 7:
		pipeGap = 165
	elif score == 10:
		$Timer.wait_time=2.6
		scrollSpeed=4.5
	elif score == 15:
		scrollSpeed=4.7
		pipeGap = 140
	else:
		if score%5==0 && score!=0:
			scrollSpeed+=0.3;
			$Timer.wait_time-=0.1;
			
	
	
	
