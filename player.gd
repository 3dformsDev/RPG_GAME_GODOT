class_name  Player extends CharacterBody2D

signal attack_finished

@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent


var move_speed := 100
var attack_damage := 50
var is_atttack := false

func _ready() -> void:
	health_component.death.connect(on_death)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				attack()
			
func _physics_process(delta: float) -> void:
	if !is_atttack:
		var move_direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		
		if move_direction:
			velocity = move_direction * move_speed
			sprite_animation.play("run")
			if move_direction.x != 0:
				sprite_animation.flip_h = move_direction.x < 0
				$AreaAttack.scale.x = -1 if move_direction.x < 0 else 1
		else:
			velocity = velocity.move_toward(Vector2.ZERO, move_speed)
			sprite_animation.play("idle")
		
		move_and_slide()
				
func attack():
	sprite_animation.play("attack")
	is_atttack = true
	
func on_death():
	print("GAME OVER")
	get_tree().paused = true

#aqui termina la animacion de ataque
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		is_atttack = false
		attack_finished.emit()
		


# Enemigo en zona de ataque
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.in_attack_player_range = true
		



# Enemigo no esta en zona de ataque
func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Enemy:
		body.in_attack_player_range = false
