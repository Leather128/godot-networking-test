class_name Guy extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting('physics/2d/default_gravity')

@onready var sprite: Sprite2D = $sprite

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))
	
	if is_multiplayer_authority():
		position.x = 640.0

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	$'../camera'.target = self
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis('left', 'right')
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event is InputEventKey:
		var key_event: InputEventKey = event
		
		match key_event.keycode:
			KEY_0:
				sprite.modulate = Color.WHITE
			KEY_1:
				sprite.modulate = Color.RED
			KEY_2:
				sprite.modulate = Color.BLUE
			KEY_3:
				sprite.modulate = Color.GREEN
			KEY_4:
				sprite.modulate = Color.ORANGE
			KEY_5:
				sprite.modulate = Color.MAGENTA
