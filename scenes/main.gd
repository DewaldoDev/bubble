extends Node
@export var pipeScene : PackedScene

signal audio_changed(db_level)

var gameRun : bool
var score
const scrollSpeed : int = 2
var pipes : Array
const pipeDelay : int = 100
const pipeRange : int = 150
const pipeGap : int = 200;
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	newGame()

func newGame():
	gameRun = false
	score = 0
	pipes.clear()
	_on_timer_timeout()
	startGame() #remove this once blowing bubble start thing is finished
	
func startGame():
	gameRun=true;
	$Timer.start()
	
func _input(event): # temp start game condition
	if !gameRun:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				startGame()
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gameRun:
		for pipe in pipes:
			pipe.position.x -= scrollSpeed
	
	var db_level = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Capture"), 0)
	audio_changed.emit(db_level)
	

func _on_timer_timeout() -> void:
	var pipeObj1 = pipeScene.instantiate()
	var pipeObj2 = pipeScene.instantiate()
	
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
	$Timer.stop()
	gameRun=false
	$bubble.pop()

func scoreIncrement():
	score+=1
	print(score)
	
