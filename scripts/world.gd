extends Node3D

@onready var enemy_scene = load("res://scenes/enemy.tscn")

func _ready() -> void: #Called when the node enters the scene tree for the first time.
	$Timer.wait_time = randi_range(1, 5) #Create Random Time (Between 1 & 5 Seconds)
	$Timer.start() #Start Timer

func _on_timer_timeout() -> void: #When Timer Ends
	$Timer.wait_time = randi_range(1, 5) #Change Timer to Something Random (1 - 5 Seconds)
	var instance = enemy_scene.instantiate() #Create a new Enemy
	instance.position = Vector3(randi_range(-25, 25), 0, randi_range(-25, 25)) #Choose a Random Place to Spawn the Enemy
	$Enemies.add_child(instance) #Add the Enemy to the Enemies Node
	instance.spawned = true #Tell the Enemy it has spawned
	$Timer.start() #Restart the Timer (To spawn a new Enemy)
