extends Area2D

@export var speed = 100
@export var shape = "square"
@export var width = 5
@export var length = 5
@export var time = 1
@export var range = 100
@export var theta = 0 #direction to travel in radians
@export var attack_name = "none"
var velocity

func create():
	#create the collision shape
	match shape:
		"square":
			assert(width==length)
			var collision_shape = RectangleShape2D.new() 
			collision_shape.size = width
			$Shape.shape = collision_shape
		"circle":
			assert(width==length)
			var collision_shape = CircleShape2D.new()
			collision_shape.radius = width
			$Shape.shape = collision_shape
		"triangle":
			var point_array = [Vector2(-1*width/2,range/2),Vector2(width/2,range/2),Vector2(0,-range/2)]
			var collision_shape = ConvexPolygonShape2D.new() 
			collision_shape.points = point_array
			$Shape.shape = collision_shape
	#create the sprite
	var sprite = load("res://assets/projectiles/"+ attack_name + ".tscn").instantiate()
	sprite.play()
	add_child(sprite)
	#assign any other variables
	velocity = Vector2(sin(theta), -cos(theta))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#travel in the given direction
	position += velocity.normalized() * speed * delta
	#take delta off time to live
	time -= delta
	if time <= 0: #if time has run out, we kill the attack
		queue_free()
