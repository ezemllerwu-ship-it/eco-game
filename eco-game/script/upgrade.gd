class_name Upgrade
extends Button
# ============================================================
#  UPGRADE  (the base that all upgrades are built on)
# ============================================================
# Every upgrade is a button you can buy ONE time.
#
# Don't put this script on a button yourself. Use one of these:
#   add_upgrade.gd       -> adds money       (example: +$5 to click money)
#   multiply_upgrade.gd  -> multiplies money (example: x2 income)
#
# main.gd finds every upgrade by itself, so you never have to
# change main.gd when you add a new upgrade.


# The things an upgrade can change.
enum Affects { CLICK, INCOME, BOTH }

# ----- Settings you can change in the Inspector -----
@export var upgrade_name: String = "Upgrade"
@export var affects: Affects = Affects.CLICK
@export var cost: int = 10

# Has the player bought this upgrade yet?
var bought: bool = false


func _ready() -> void:
	# Join the "upgrades" group so main.gd can find this button.
	add_to_group("upgrades")
	# Make the button tall enough for 3 lines of text.
	custom_minimum_size.y = 90


# Does this upgrade change "thing"? (thing is CLICK or INCOME)
func does_affect(thing: Affects) -> bool:
	if affects == Affects.BOTH:
		return true
	return affects == thing


# How much money this upgrade ADDS to "thing".
# By default it adds nothing. add_upgrade.gd changes this.
func get_amount_added(_thing: Affects) -> int:
	return 0


# What this upgrade MULTIPLIES "thing" by.
# By default it's x1 (no change). multiply_upgrade.gd changes this.
func get_multiplier(_thing: Affects) -> float:
	return 1.0


# The line of text that says what the upgrade does.
# Each kind of upgrade writes its own.
func get_description() -> String:
	return ""


# Turns the "affects" setting into words for the button.
func get_affects_text() -> String:
	if affects == Affects.CLICK:
		return "click money"
	elif affects == Affects.INCOME:
		return "income"
	else:
		return "click money and income"


# Updates the button's text. main.gd calls this whenever money changes.
func update_button(money: int) -> void:
	if bought:
		text = upgrade_name + "\n" + get_description() + "\nOWNED"
		disabled = true
	else:
		text = upgrade_name + "\n" + get_description() + "\nCost: $" + str(cost)
		# Grey the button out if the player can't afford it.
		disabled = money < cost
