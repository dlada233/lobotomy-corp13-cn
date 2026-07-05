//Axe Gang is just garbage for the backstreets.

/obj/item/ego_weapon/city/axegang
	name = "斧头帮斧头" //原文 axe gang axe
	desc = "街头斧头帮使用的斧头."
	icon_state = "axe_grunt"
	force = 16
	attack_speed = 1.4
	damtype = RED_DAMAGE

	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/ego/axe2.ogg'

/obj/item/ego_weapon/city/axegang/leader
	name = "斧头帮大斧头"
	desc = "街头斧头帮的领袖使用的斧头."
	icon_state = "axe_gang"
	force = 21
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 40,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)

