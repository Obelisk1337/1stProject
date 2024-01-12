extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 0
var jump_max = 2
var jump_count = 0
var ani = "default"
var doubleframe = 0 

func _physics_process(delta):
	#animations
	if (velocity.x > 1 || velocity.x < -1) and is_on_floor(): 
		ani = "running"
		
	else:
		ani = "default" 
		
			
	#resting jump count
	if is_on_floor() and jump_count!=0:
		jump_count = 0
		

	# Handle Jump.
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 1:
			if sprite_2d.animation != "double": 
				ani = "jumping"
				
		if velocity.y > 1:
			ani = "falling"
			
	if Input.is_action_just_pressed("Jump"): 
	
		if is_on_wall_only():
			jump_count = 0
			print(is_on_floor(), jump_count)
			velocity.x = JUMP_VELOCITY/2
			velocity.y = JUMP_VELOCITY
		elif jump_count!=jump_max:
			velocity.y = JUMP_VELOCITY
			if jump_count == 1:
				ani = "double"
				doubleframe = 1
			jump_count += 1
	
		
		
	# Animate
	doubleframe += 1
	if ani == "double" or doubleframe >= 19 or doubleframe == 0:
		if sprite_2d.animation_changed:
			print(sprite_2d.animation)
		sprite_2d.animation = ani
		
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 30) 

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func set_direction():
	direction = 1 if not$Sprite2D.flip_h else -1
	
	
	

