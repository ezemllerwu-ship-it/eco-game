class_name MultiplyUpgrade
extends Upgrade
# ============================================================
#  MULTIPLY UPGRADE
# ============================================================
# A one-time upgrade that MULTIPLIES money.
# Example: multiplier = 2, affects = INCOME  ->  income is doubled.
# Multipliers stack: two x2 upgrades = x4.

@export var multiplier: float = 2.0


func get_multiplier(thing: Affects) -> float:
	if does_affect(thing):
		return multiplier
	return 1.0


func get_description() -> String:
	# String.num() shows 2.0 as "2" and 1.5 as "1.5".
	return "x" + String.num(multiplier) + " " + get_affects_text()
