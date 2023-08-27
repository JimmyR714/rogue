extends CharacterBody2D

var screen_size
var speed = 300

#auxiliary functions
func create_timer(cooldown, function, num):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = cooldown
	timer.one_shot = true
	timer.timeout.connect(Callable(set_attack_ready).bind(num))
	timer.start()

#runs when it enters scene
func _ready():
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#process movement
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		$Sprite.animation = "right"
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$Sprite.animation = "left"
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		$Sprite.animation = "down"
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		$Sprite.animation = "up"

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$Sprite.play()
	else:
		$Sprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#process attacks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#do main attack
		choose_attack(1)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#do secondary attack
		choose_attack(2)
	if Input.is_key_pressed(KEY_E):
		#use util 1
		choose_util(3)
	if Input.is_key_pressed(KEY_Q):
		#use util 2
		choose_util(4)
		
	#quit game
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		
#attack functions
var attack_ready = true
var attack_1_ready = true
var attack_2_ready = true
var util_1_ready = true	
var util_2_ready = true

var atk_1 = {
	"name": "claw",
	"damage": 100,
	"range": 0,
	"width": 5,
	"length": 20,
	"knockback": 5,
	"time": 0.5,
	"speed": 0,
	"shape": "triangle",
	"cooldown": 1
}
var atk_2 = {
	"name": "bullet",
	"damage": 200,
	"range": 1000,
	"width": 5,
	"length": 5,
	"knockback": 1,
	"time": 10,
	"speed": 800,
	"shape": "circle",
	"cooldown": 0.3
}

func attack(atk):
	var dir = calculate_attack_direction()
	#create a projectile that can collide with enemies
	var projectile = load("res://scenes/projectile.tscn").instantiate()
	projectile.attack_name = atk["name"]
	projectile.speed = atk["speed"]
	projectile.shape = atk["shape"]
	projectile.range = atk["range"]
	projectile.width = atk["width"]
	projectile.length = atk["length"]
	projectile.time = atk["time"]
	projectile.theta = dir
	projectile.position = Vector2(position.x+50,position.y+75)
	get_parent().add_child(projectile)
	projectile.create()

#choose the correct attack
func choose_attack(num):
	var attacked = false
	if attack_ready:
		#set specific attack stuff and do attack
		if num==1 && attack_1_ready:
			attack(atk_1)
			create_timer(atk_1["cooldown"], set_attack_ready, 1) #create number specific cooldown	
			attack_1_ready = false
			attacked = true
		elif num==2 && attack_2_ready:
			attack(atk_2)
			create_timer(atk_2["cooldown"], set_attack_ready, 2)
			attack_2_ready = false
			attacked = true
		
		#set general attack stuff	
		if attacked:
			create_timer(0.2, set_attack_ready, 0) #create general attack cooldown
			attack_ready = false

func set_attack_ready(num):
	match num:
		0:
			attack_ready = true
		1:
			attack_1_ready = true
		2:
			attack_2_ready = true

#choose correct util
func choose_util(num):
	pass

#returns attack direction in radians from north of character
#includes constants used in character size
func calculate_attack_direction():
	var mouse = get_viewport().get_mouse_position()
	var theta
	var x = position.x + 50
	var y = position.y + 75
	if mouse.x < x:
		if mouse.y <= y:
			#top left
			theta = atan((y-mouse.y)/(x-mouse.x)) + 3*PI/2
		else:
			#bottom left
			theta = atan((x-mouse.x)/(mouse.y-y)) + PI
	else:
		if mouse.y <= y:
			#top right
			theta = atan((mouse.x-x)/(y-mouse.y))
		else:
			#bottom right
			theta = atan((mouse.y-y)/(mouse.x-x)) + PI/2
	return theta
