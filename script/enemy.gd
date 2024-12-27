class_name Enemy extends CharacterBody2D

@onready var player: Player = $"../Player"  #algo pasa aqui?
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent



var move_speed := 50
var attack_damage := 10
var is_attack := false
var in_attack_player_range := false

func _ready() -> void:
	health_component.death.connect(on_death)
	if player:
		player.attack_finished.connect(verify_receive_damage)

func _physics_process(delta: float) -> void:
	if !is_attack and player:
		sprite_animation.play("run")
		
		var move_direction = (player.position - position).normalized()
		if move_direction:
			velocity = move_direction * move_speed
			if move_direction.x != 0:
				sprite_animation.flip_h = move_direction.x <0
				$AreaAttack.scale.x = -1 if move_direction.x < 0  else 1
			
		move_and_slide()
		
func Attack():
	sprite_animation.play("attack")
	is_attack = true

func verify_receive_damage():
	if in_attack_player_range:
		health_component.receive_damage(player.attack_damage)

func on_death():
	queue_free()
	

# Cuando el player entra en la zona de ataque.
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		Attack()

# Cuando el player sale de la zona de ataque.
func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Player:
		is_attack = false
		


# Cuando termine la animacion de ataque 
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		player.health_component.receive_damage(attack_damage)
		if is_attack:
			Attack()
