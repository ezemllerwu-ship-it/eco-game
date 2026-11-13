extends Node2D
var up_grade_cost = 10
var money = 0
var add = 1
@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	money_label.text = "Money: $" + str(money)

func _process(delta: float) -> void:
	money_label.text = "Money: $" + str(money)

func _on_button_pressed() -> void:
	money += add

func _on_button_upgrade_pressed() -> void:
	if money >= up_grade_cost:
		money -= up_grade_cost
		add += 1
		up_grade_cost *= 1.5
		

	
