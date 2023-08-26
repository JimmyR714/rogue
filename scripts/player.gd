extends CharacterBody2D

var screen_size
var speed = 300

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
	"type": "melee",
	"damage": 100,
	"range": 20,
	"width": 5,
	"knockback": 5
}
var atk_2 = {
	"type": "ranged",
	"damage": 200,
	"range": 1000,
	"width": 5,
	"knockback": 1
}


func attack(type, damage, range, width, knockback):
	pass
	#create a triangle of area in which enemies should be hit
	
	#do damage to all of them accordingly

#choose the correct attack
func choose_attack(num):
	if attack_ready:
		if num==1 && attack_1_ready:
			attack(atk_1["type"], atk_1["damage"], atk_1["range"], atk_1["width"], atk_1["knockback"])
		elif num==2 && attack_2_ready:
			attack(atk_2["type"], atk_2["damage"], atk_2["range"], atk_2["width"], atk_2["knockback"])

#choose correct util
func choose_util(num):
	pass

#returns attack direction in degrees from north of character
func calculate_attack_direction():
	var mouse = get_viewport().get_mouse_position()
	var theta
	if mouse.x < position.x:
		if mouse.y >= position.y:
			#top left
			theta = atan((mouse.y-position.y)/(mouse.x-position.x)) + 270
		else:
			#bottom left
			theta = atan((position.y-mouse.y)/(mouse.x-position.x)) + 180
	else:
		if mouse.y >= position.y:
			#top left
			theta = atan((mouse.y-position.y)/(position.x - mouse.x))
		else:
			#bottom left
			theta = atan((position.y-mouse.y)/(position.x-mouse.x)) + 90
	return theta
