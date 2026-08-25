//黎明事务所 uses an AOE flame after hitting two different things. Grade 5
/obj/item/ego_weapon/city/dawn
	name = "黎明事务所 template"
	desc = "A template for 黎明事务所 weapons."
	special = "Hit one enemy, then the other to unleash a weak aoe attack."
	icon_state = "philip"
	inhand_icon_state = "philip"
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	var/aoe_range
	var/aoe_target
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)

/obj/item/ego_weapon/city/dawn/attack(mob/living/target, mob/living/user)
	//Happens before the attack so you need to do another attack.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			H.death()
	..()
	//not if they're dead
	if(target.stat == DEAD)
		return
	if(aoe_target && (target != aoe_target))
		playsound(src, 'sound/weapons/ego/cannon.ogg', 50, TRUE)
		for(var/turf/T in view(aoe_range, target))
			if(prob(30))
				new /obj/effect/temp_visual/fire/fast(T)
			user.HurtInTurf(T, list(), force*0.2, damtype, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_SPECIAL))
	aoe_target = target

//Philip's Sword
/obj/item/ego_weapon/city/dawn/sword
	name = "黎明事务所 阔剑"
	desc = "一柄普通的剑，但剑柄里有一个损坏的加热装置."
	icon_state = "philip"
	inhand_icon_state = "philip"
	force = 17
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	aoe_range = 2

//Yuna's Cello Case
/obj/item/ego_weapon/city/dawn/cello
	name = "黎明事务所 大提琴箱"
	desc = "为黎明事务所的收尾人定制的大提琴箱，内部装满了可伸缩的刀刃..."
	icon_state = "yuna"
	inhand_icon_state = "yuna"
	force = 20		//Bigger range, less force
	attack_speed = 1.5
	aoe_range = 5
	swingstyle = WEAPONSWING_SMALLSWEEP

//Salvador's Zweihander
/obj/item/ego_weapon/city/dawn/zwei
	name = "黎明事务所 双手大剑"
	desc = "一把装有加热装置的双手大剑，刀刃会灼烧你的敌人."
	icon_state = "salvador"
	inhand_icon_state = "salvador"
	force = 25		//Bigger range, less force
	attack_speed = 2
	aoe_range = 7
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
