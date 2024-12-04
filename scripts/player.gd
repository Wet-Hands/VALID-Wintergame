extends CharacterBody3D

@onready var cam = $Head/Camera3D #Declaring Camera3D Reference
@onready var ray = $Head/Camera3D/RayCast3D #Declaring RayCast3D Reference
var cam_sens = 0.25 #Camera Movement Sensitivity
var is_bob_playing = false #Is The Player's Head Bobbing?

var fs = false #Fullscreen Variable (Windowed by Default)

const SPEED = 5.0 #Constant Speed Variable

var can_shoot : bool = true #Can the Player Shoot?

func _ready() -> void: #Script Runs Immediately
	Engine.max_fps = 60 #Set FPS to 60
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN #Temp Fix for working on Virtual Machine
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #How mouse movement SHOULD work

func _input(event): #When any input is made, better than checking constantly with _process
	if event is InputEventMouseMotion: #If mouse is moving
		$Head.rotate_y(-event.relative.x * cam_sens * get_process_delta_time()) #Look left and right
		cam.rotate_x(-event.relative.y * cam_sens * get_process_delta_time()) #Look up and down
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-80), deg_to_rad(80)) #Stop turning so player's neck doesn't break
	if Input.is_action_just_pressed("exit"):#when backspace is pressed
		get_tree().quit() #quits game
	if Input.is_action_just_pressed("action1"): #If Action1 (Left Mouse Click) is Pressed
		shoot() #Shoot Function
	if Input.is_action_just_pressed("fullScreen"): #If Fullscreen (F Key) is Pressed
		if fs == false: #If not Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) #Make Fullscreen
			fs = true #Fullscreen is Active
		else: #If Fullscreen Already
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) #Make Windowed
			fs = false #Fullscreen is NOT Active

func _physics_process(delta: float) -> void: #Plays every frame Physics is Active (Every Frame)
	if not is_on_floor(): #If Player is In-Air
		velocity += get_gravity() * delta #Add's Gravity to the Velocity

	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBack") #Get the input direction and handle the movement/deceleration.
	var direction = ($Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() #Sets Player Direction based on input_dir & which way the player faces
	if direction: #If Direction is not ZERO
		velocity.x = direction.x * SPEED #Apply Velocity in X Direction
		velocity.z = direction.z * SPEED #Apply Velocity in Z Direction
		head_bob() #Head Bob Function (Plays Bob Animation)
	else: #If Player is not Moving
		velocity.x = move_toward(velocity.x, 0, SPEED) #Stop the Player in the X Direction
		velocity.z = move_toward(velocity.z, 0, SPEED) #Stop the Player in the Z Direction

	move_and_slide() #Activates Movement

func head_bob(): #Head Bob Function
	if is_bob_playing == false: #If the Player's Head isn't bobbing
		is_bob_playing = true #Player's Head is now bobbing
		$AnimationPlayer.play("bob") #Play the Headbob Animation

func _on_animation_player_animation_finished(anim_name: StringName) -> void: #When Headbob is Complete
	if anim_name == "bob": #If the finished Animation is "bob"
		is_bob_playing = false #The Player's Head is NOT bobbing

func shoot(): #Shoot Function
	if can_shoot == false: #If the Player Can't Shoot
		print(can_shoot) #Print Test
		return #End Function (No Code Below will Run)
	can_shoot = false #Player now can't shoot
	$UI/GunSprite.play("fire") #Play Gunfire Animation
	if ray.is_colliding(): #If RayCast3D is Colliding with Something
		if ray.get_collider().has_method("dmg"): #Does the Something have the 'dmg' function? (HINT: Only the Enemy Scene will have this function)
			ray.get_collider().dmg(10) #If so, deal 10 damage to the Enemy

func _on_gun_sprite_animation_finished() -> void: #When Gunfire Animation Finishes
	can_shoot = true #The Player can Shoot
