/mob/living/simple_animal/hostile/abnormality/red_queen
	name = "红皇后"
	desc = "她椅子上坐着一个高贵的红色怪人."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "redqueen"
	portrait = "red_queen"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_upper = 5
	work_damage_lower = 1
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth

	ego_list = list(
		/datum/ego_datum/weapon/fury,
		/datum/ego_datum/armor/fury,
	)
	gift_type = /datum/ego_gifts/fury
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "该异常实体因工作过程极度枯燥而声名狼藉。<br>难以揣测其倾向或偏好。<br>\
		你将尝试何种工作？"
	observation_choices = list( // 匹配红皇后的真实偏好
		ABNORMALITY_WORK_INSTINCT = list(FALSE, "纸牌铡刀擦过你的脖颈，惊险躲过一劫，换种方式试试。"),
		ABNORMALITY_WORK_INSIGHT = list(FALSE, "纸牌铡刀擦过你的脖颈，惊险躲过一劫，换种方式试试。"),
		ABNORMALITY_WORK_ATTACHMENT = list(FALSE, "纸牌铡刀擦过你的脖颈，惊险躲过一劫，换种方式试试。"),
		ABNORMALITY_WORK_REPRESSION = list(FALSE, "纸牌铡刀擦过你的脖颈，惊险躲过一劫，换种方式试试。"),
	)
	var/liked

/mob/living/simple_animal/hostile/abnormality/red_queen/Initialize(mapload)
	. = ..()
	//What does she like?
	//Pick it once so people can find out
	liked = pick(ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION)

/mob/living/simple_animal/hostile/abnormality/red_queen/PostSpawn()
	. = ..()
	observation_choices[liked] = list(TRUE, "你获准觐见红皇后。<br>今日你恰好满足了她变幻莫测的兴致.")
	var/list/potential_work_values = list(0, 35)
	for(var/work in work_chances)
		if(work == ABNORMALITY_WORK_INSTINCT)
			continue
		if(work == liked)
			work_chances[work] = 65
		else
			var/picked = pick(potential_work_values)
			work_chances[work] = picked
			potential_work_values -= picked
	datum_reference.available_work = work_chances

/mob/living/simple_animal/hostile/abnormality/red_queen/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	user.visible_message(span_warning("无形利刃斩过[user]的脖颈!"))
	user.deal_damage(100, RED_DAMAGE)
	new /obj/effect/temp_visual/slice(get_turf(user))

	//Fitting sound, I want something crunchy, and also very loud so everyone knows
	playsound(src, 'sound/weapons/guillotine.ogg', 75, FALSE, 4)

	if(user.health < 0)
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//OFF WITH HIS HEAD!
		if(!istype(head))
			return FALSE
		head.dismember()
