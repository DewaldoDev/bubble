extends Node
@export var pipeScene : PackedScene

var gameRun : bool
var score
const scrollSpeed : int = 2
var pipes : Array
const pipeDelay : int = 100
const pipeRange : int = 200
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
	
	

func _on_timer_timeout() -> void:
	var pipeObj = pipeScene.instantiate()
	pipeObj.scale = Vector2(2,2)
	pipeObj.position.x = screen_size.x + pipeDelay
	pipeObj.position.y = (screen_size.y) / 2 + randi_range(-pipeRange, pipeRange)
	pipeObj.hit.connect(stopGame)
	pipeObj.scored.connect(scoreIncrement)
	add_child(pipeObj)
	pipes.append(pipeObj)
	
func stopGame():
	$Timer.stop()
	gameRun=false
	print("you died")

func scoreIncrement():
	score+=1
	print(score)
	
