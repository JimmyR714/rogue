extends CharacterBody2D

var screen_size
var speed = 300

#runs when it enters scene
func _ready():
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#process movement
	var velocity = Vector2.ZERO # The player's movement vector.
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
	
	#quit game
	if Input.is_action_pressed("quit"):
		get_tree().quit()
