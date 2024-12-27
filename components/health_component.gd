class_name HealthComponent extends Node2D

signal death

@export var progress_bar : ProgressBar
@export var currient_healt := 100
@export var max_health := 100

func _ready() -> void:
	update_healt_bar()

func update_healt_bar():
	if progress_bar:
		progress_bar.value = currient_healt

#aplicar daño
func receive_damage(amount: int):
	currient_healt = clamp(currient_healt - amount, 0, max_health)
	update_healt_bar()
	
	if currient_healt <=0:
		on_death()

# curar daño // PENDIENTE POR USAR
func apply_damage(amount: int):
	currient_healt = clamp(currient_healt + amount, 0, max_health)
	update_healt_bar()
	
func on_death():
	print("Personaje Murió")
	death.emit()
	
