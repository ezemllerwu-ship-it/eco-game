extends Control
# ============================================================
#  MAIN GAME
# ============================================================
# You get money in two ways:
#   1. Clicking the big button  -> get_click_money()
#   2. Income every second      -> get_income()
# Upgrades make both of these bigger.


# ----- Starting values (change these in the Inspector) -----
@export var starting_click_money: int = 1
@export var starting_income: int = 0

var money: int = 0

# A list of every upgrade in the game. Filled in by _ready().
var upgrades: Array[Upgrade] = []

@onready var money_label: Label = %MoneyLabel
@onready var income_label: Label = %IncomeLabel
@onready var click_button: Button = %ClickButton


func _ready() -> void:
	# Find every upgrade button in the scene.
	for upgrade in get_tree().get_nodes_in_group("upgrades"):
		upgrades.append(upgrade)
		# When this upgrade is pressed, call buy_upgrade() and
		# tell it WHICH upgrade was pressed.
		upgrade.pressed.connect(buy_upgrade.bind(upgrade))
	update_screen()


# ------------------------------------------------------------
#  GETTING MONEY
# ------------------------------------------------------------

# Runs when the big button is clicked.
func _on_click_button_pressed() -> void:
	money += get_click_money()
	update_screen()


# Runs once every second (the IncomeTimer node in the scene).
func _on_income_timer_timeout() -> void:
	money += get_income()
	update_screen()


# ------------------------------------------------------------
#  BUYING UPGRADES
# ------------------------------------------------------------

func buy_upgrade(upgrade: Upgrade) -> void:
	if upgrade.bought:
		return  # already have it
	if money < upgrade.cost:
		return  # can't afford it

	money -= upgrade.cost
	upgrade.bought = true
	update_screen()


# ------------------------------------------------------------
#  MATH: how much money do clicks and income give?
# ------------------------------------------------------------

func get_click_money() -> int:
	return apply_upgrades(starting_click_money, Upgrade.Affects.CLICK)


func get_income() -> int:
	return apply_upgrades(starting_income, Upgrade.Affects.INCOME)


# Takes a starting value and applies every bought upgrade to it.
# All the ADDS happen first, then all the MULTIPLIES.
#
# Example: start at 1, bought +1, +5 and x2
#          (1 + 1 + 5) x 2 = 14
func apply_upgrades(start_value: int, thing: Upgrade.Affects) -> int:
	var value: float = start_value

	# Step 1: add
	for upgrade in upgrades:
		if upgrade.bought:
			value += upgrade.get_amount_added(thing)

	# Step 2: multiply
	for upgrade in upgrades:
		if upgrade.bought:
			value *= upgrade.get_multiplier(thing)

	# Round to a whole number so money stays an int.
	return roundi(value)


# ------------------------------------------------------------
#  SCREEN
# ------------------------------------------------------------

# Updates every label and button. Call this whenever money changes.
func update_screen() -> void:
	money_label.text = "Money: $" + str(money)
	income_label.text = "Income: $" + str(get_income()) + " per second"
	click_button.text = "Click!\n+$" + str(get_click_money())

	for upgrade in upgrades:
		upgrade.update_button(money)
