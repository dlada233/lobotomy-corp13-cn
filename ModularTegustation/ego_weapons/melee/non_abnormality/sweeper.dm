//Regular is Grade 7, rest are grade 5
/obj/item/ego_weapon/city/sweeper
	name = "清道夫钩"
	desc = "清道夫使用的钩子，当夜幕降临在后巷..."
	special = "攻击死亡的尸体来治愈自己."
	icon_state = "sweeper_hook"
	force = 13
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("stabs")
	attack_verb_simple = list("stab")
	hitsound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 40,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)

/obj/item/ego_weapon/city/sweeper/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	if((target.stat == DEAD) && !(target.status_flags & GODMODE))
		target.gib()
		user.adjustBruteLoss(-user.maxHealth * 0.1)	//Heal 10% HP

/obj/item/ego_weapon/city/sweeper/sickle
	name = "清道夫镰刀"
	desc = "清道夫使用的镰刀，当夜幕降临在后巷..."
	icon_state = "sweeper_sickle"
	force = 18
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/sweeper/hooksword
	name = "清道夫钩剑"
	desc = "清道夫使用的钩剑，当夜幕降临在后巷..."
	icon_state = "sweeper_hooksword"
	force = 27
	attack_speed = 1.6
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/sweeper/claw
	name = "清道夫爪"
	desc = "清道夫队长被砍下的爪子。当夜幕降临在后巷..."
	icon_state = "sweeper_claw"
	force = 12
	attack_speed = 0.6
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
