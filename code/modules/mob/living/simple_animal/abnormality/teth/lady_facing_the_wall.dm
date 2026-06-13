/mob/living/simple_animal/hostile/abnormality/wall_gazer
	name = "面壁女"
	desc = "一个苍白的裸体女人，长着黑色的长发，完全遮住了她的脸."
	icon = 'ModularTegustation/Teguicons/96x48.dmi'
	icon_state = "ladyfacingthewall"
	portrait = "lady_facing_the_wall"
	maxHealth = 200
	health = 200
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 55, 55, 55),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 30, 30, 0),
		ABNORMALITY_WORK_ATTACHMENT = list(100, 100, 100, 100, 100),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 30, 30, 30),
	)
	pixel_x = -32
	base_pixel_x = -8

	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	start_qliphoth = 2
	var/scream_range = 10
	var/scream_damage = 25
	ego_list = list(
		/datum/ego_datum/weapon/wedge,
		/datum/ego_datum/armor/wedge,
	)
	gift_type =  /datum/ego_gifts/wedge
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "一个女人正在哭泣. \
		你背对着她无法看见面容，但你知道她是谁. \
		她含糊的低语令人难以理解，使你寒毛直竖. 她含糊的低语令人难以理解，使你寒毛直竖. \
		女人的啜泣仿佛在逼迫你转身. \
		而你内心深处有个声音警告着：绝不能回头."
	observation_choices = list(
		"转身" = list(TRUE, "你直面恐惧，转身面向那个女人."),
		"不要转身" = list(FALSE, "转身可能引发恐怖之事，你头也不回地离开了房间."),
	)

/mob/living/simple_animal/hostile/abnormality/wall_gazer/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/ZeroQliphoth(mob/living/carbon/human/user)
	scream()
	datum_reference.qliphoth_change(start_qliphoth)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/proc/scream()
	for(var/mob/living/L in range(scream_range, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		playsound(get_turf(src), 'sound/spookoween/girlscream.ogg', 400)
		L.deal_damage(scream_damage, WHITE_DAMAGE)

/mob/living/simple_animal/hostile/abnormality/wall_gazer/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// If you do work while having low Temperance, fuck you and you go insane for turning your back to face her
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		datum_reference.qliphoth_change(-1)

	if((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40) && !(GODMODE in user.status_flags))
		flick("ladyfacingthewall_active", src)
		user.adjustSanityLoss(user.maxSanity)
		user.apply_status_effect(/datum/status_effect/panicked_lvl_4)
	return
