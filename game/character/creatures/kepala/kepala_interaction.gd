extends "res://interaction/interaction.gd"

func interact(item):
	if not item:
		var inv = get_node("/root/Main").get_inventory()
		var kin_body = get_node("../..")
		if (kin_body.is_alive() and kin_body.get_node("DmgCooldown").is_stopped()) and \
		   (inv.next_empty_slot() != -1 or inv.how_many_of_item("Hair") != 0):
			inv.give_items("Hair", 1)
			kin_body.damage(1)
