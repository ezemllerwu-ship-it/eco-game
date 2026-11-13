class_name AddUpgrade
extends Upgrade
# ============================================================
#  ADD UPGRADE
# ============================================================
# A one-time upgrade that ADDS money.
# Example: amount = 5, affects = CLICK  ->  every click gives $5 more.

@export var amount: int = 1


func get_amount_added(thing: Affects) -> int:
	if does_affect(thing):
		return amount
	return 0


func get_description() -> String:
	return "+$" + str(amount) + " to " + get_affects_text()
