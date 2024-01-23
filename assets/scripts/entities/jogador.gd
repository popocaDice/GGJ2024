extends CharacterBody2D
class_name Player
@export var JUMP_FORCE: int = -130
@export var JUMP_RELEASE_FORCE: int = -70
@export var MAX_SPEED: int = 50
@export var ACCELERATION: int = 10
@export var FRICTION: int = 10
@export var GRAVITY: int = 4
@export var ADDITIONAL_FALL_GRAVITY: int = 4

@onready var animatedSprite = $AnimatedSprite2D
@onready var pieProjectile = preload("res://assets/prefabs/projectiles/Pie.tscn")

var jumpInput = false
var attack = false

func _ready():
	pass
	
func _physics_process(delta):
	apply_gravity()
	
	if Input.is_action_just_pressed("Pie"):
		attack = true
		
	if attack:
		var pie = pieProjectile.instantiate()
		get_tree().root.add_child(pie)
		pie.global_position = global_position
		pie.get_child(0).flip_h = $AnimatedSprite2D.flip_h
		pie.Throw()
		attack = false
		return
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:	
		apply_friction()
		animatedSprite.play("Parado")
	else:
		apply_acceleration(input.x)
		animatedSprite.play("Andando")
		if input.x > 0:
			animatedSprite.flip_h = true
		elif input.x < 0:
			animatedSprite.flip_h = false
				
	
	if is_on_floor():
		jumpInput = false
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_FORCE
			jumpInput = true
	else:
		animatedSprite.play("Pulo")
		if Input.is_action_just_released("Jump") and jumpInput and velocity.y <= JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
			jumpInput = false

		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	var was_in_air = is_on_floor()
	move_and_slide()
	var just_landed = is_on_floor() and not was_in_air
	if just_landed:
		animatedSprite.animation = "Andando"
		animatedSprite.frame = 1
		
func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

