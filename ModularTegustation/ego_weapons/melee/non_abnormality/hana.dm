//Grade 3, the only hana weapon right now.
/obj/item/ego_weapon/city/hana
	name = "하나协会武器系统"
	desc = "하나协会的武器系统，永远三种不同的形态，分别是长矛，剑与手甲."
	special = "在手中使用来改变武器形态."	//like a different rabbit knife. No black though
	icon_state = "hana_sword"
	force = 25
	damtype = PALE_DAMAGE

	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/fixer/hana_slash.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 100,
	)
	var/mode = 1

/obj/item/ego_weapon/city/hana/attack_self(mob/living/user)
	var/message
	switch(mode)
		if(1)
			mode = 2
			icon_state = "hana_spear"
			message = "这把武器现在处于长矛模式，具有额外的射程和伤害，但会对你造成眩晕."
			hitsound = 'sound/weapons/fixer/hana_pierce.ogg'
			attack_verb_continuous = list("stabs", "pierces")
			attack_verb_simple = list("stab", "pierce")

			reach = 2
			force = 30
			stuntime = 5

		if(2)
			mode = 3
			icon_state = "hana_fist"
			message = "这把武器现在处于拳套模式，每次攻击造成更多伤害，但攻击速度较慢."
			hitsound = 'sound/weapons/fixer/hana_blunt.ogg'
			attack_verb_continuous = list("smashes", "beats")
			attack_verb_simple = list("smash", "beat")

			reach = 1
			force = 45
			attack_speed = 1.5
			stuntime = 0

		if(3)
			mode = 1
			icon_state = "hana_sword"
			message = "这把武器现在处于剑模式，每秒造成更多伤害."
			hitsound = 'sound/weapons/fixer/hana_slash.ogg'
			attack_verb_continuous = list("cuts", "slices")
			attack_verb_simple = list("cuts", "slices")

			force = 25
			attack_speed = 1
			stuntime = 0

	to_chat(user, span_notice("[message]"))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
