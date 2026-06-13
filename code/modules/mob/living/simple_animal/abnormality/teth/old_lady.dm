/mob/living/simple_animal/hostile/abnormality/old_lady
	name = "老妇人"
	desc = "一位年老体弱的老太太坐在一把破旧的摇椅上."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "old_lady"
	portrait = "old_lady"
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(65, 65, 60, 60, 60),
		ABNORMALITY_WORK_REPRESSION = 30,
		"清理孤独" = -100,
	)
	start_qliphoth = 4
	work_damage_upper = 3
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom
	ego_list = list(
		/datum/ego_datum/weapon/solitude,
		/datum/ego_datum/armor/solitude,
	)
	gift_type =  /datum/ego_gifts/solitude
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "地板上有些裂缝。\
		木摇椅发出令人毛骨悚然的吱呀声。我不想进入这栋房子。\
		因为我不喜欢听故事。虫子在这里嗡嗡地飞来飞去。\
		当我踩上去时，某种粘滑的东西爆开了。我发现了她。她脸上的每个孔洞都爬满了虫子。\
		我不想待在这里。我想出去。这里潮湿、恶心、可怕。我再也受不了了。"
	observation_choices = list(
		"留下" = list(TRUE, "我留了下来，忍受着不适。\
			她以前很健谈。最终，孤独成了唯一的听众。\
			她用手指召唤我。现在我准备好听她的故事了。"),
		"出去" = list(FALSE, "我转身逃离这个地方，又一次，我在逃跑时咬着嘴唇自责."),
	)

	var/meltdown_cooldown_time = 120 SECONDS
	var/meltdown_cooldown
//for solitude effects
	var/solitude_cooldown_time = 1 SECONDS
	var/solitude_cooldown

/mob/living/simple_animal/hostile/abnormality/old_lady/Life()
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working) // Doesn't decrease while working but will afterwards
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)

	if(solitude_cooldown < world.time && datum_reference.qliphoth_meter == 0)
		solitude_cooldown = world.time + solitude_cooldown_time
		for(var/turf/open/T in range(2 , src))
			if(prob(70))
				new /obj/effect/solitude (T)

/mob/living/simple_animal/hostile/abnormality/old_lady/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "清理孤独" && datum_reference.qliphoth_meter == 0)
		return TRUE
	else if(datum_reference.qliphoth_meter == 0 || work_type == "清理孤独")
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/old_lady/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "清理孤独")
		datum_reference.qliphoth_change(4)
		icon_state = "old_lady"
	return

//The Effect
/obj/effect/solitude
	name = "孤独气体"
	desc = "几乎看不透."
	icon = 'icons/effects/effects.dmi'
	icon_state = "solitude1"
	move_force = INFINITY
	pull_force = INFINITY
	layer = ABOVE_MOB_LAYER

/obj/effect/solitude/Initialize()
	. = ..()
	icon_state = "solitude[pick(1,2,3,4)]"
	animate(src, alpha = 0, time = 3 SECONDS)
	QDEL_IN(src, 3 SECONDS)
