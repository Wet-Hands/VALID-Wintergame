extends CharacterBody3D

@onready var player = $"../../Player" #Improper Way to Reference the Player

var speed = 1 #Speed Variable
var maxHealth = 20 #Declare Maximum Health
var health = maxHealth #Set Current Health to Max
var spawned = false #Has the Enemy been Spawned?

func _physics_process(delta: float) -> void:
	if spawned == true: #If the Enemy has been Spawned
		var direction = (player.position - position).normalized() #Get the Direction of the Player
		direction.y = 0 #Remove the Y Direction
		velocity = direction * speed #Set the Velocity the correct way to the Player
		look_at(Vector3(player.position.x, 0, player.position.z)) #Look at the Player
		move_and_slide() #Activate Movement

func dmg(num): #Damage Function
	health -= num #Subtract Health by num
	if health <= 0: #If Health reaches 0
		await get_tree().create_timer(.5).timeout #Wait a quick second (prevents weird bugs)
		queue_free() #Eliminate Enemy
