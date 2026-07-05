//Bottom tier of the syndicate workshop, still very good.

/obj/item/ego_weapon/city/district23
	name = "23号巷 屠宰刀"
	desc = "在23号巷找到的屠宰刀，这把刀锈迹斑斑，但仍能发挥作用."
	special = "This weapon heals you on hit."
	icon_state = "jack"
	force = 14
	attack_speed = 2
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE

	attack_verb_continuous = list("cleavess", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/guillotine.ogg'

/obj/item/ego_weapon/city/district23/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.2
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
	..()

/obj/item/ego_weapon/city/district23/pierre
	name = "23号巷 切肉刀"
	desc = "在23号巷找到的切肉刀，这把刀锈迹斑斑，似乎需要一些技巧来使用。"
	icon_state = "pierre"
	force = 12
	attack_speed = 1
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
