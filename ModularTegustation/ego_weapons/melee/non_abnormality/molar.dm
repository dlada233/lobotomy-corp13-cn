//Grade 4-5 Weapons, heal sanity on kill
/obj/item/ego_weapon/city/molar
	name = "臼齿 链锯剑"
	desc = "臼齿事务所使用的链锯剑. 它很重而且做工精良."
	special = "On kill, heal 30 sanity."
	icon_state = "mika"
	force = 22
	damtype = RED_DAMAGE

	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/molar/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	..()
	if(target.stat == DEAD && living)
		user.adjustSanityLoss(-15)
		living = FALSE

/obj/item/ego_weapon/city/molar/olga
	name = "臼齿 链锯刀"
	desc = "一把臼齿事务所所长使用的短链锯刀，它的链条在高速旋转时发出刺耳的声音."
	icon_state = "olga"
	force = 18
	attack_speed = 0.7
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,	//She's got bad temperance, get it? Because temperance is another word for not drinking alcohol?
							JUSTICE_ATTRIBUTE = 80
							)
	swingstyle = WEAPONSWING_LARGESWEEP
