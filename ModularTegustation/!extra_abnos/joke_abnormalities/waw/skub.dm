/mob/living/simple_animal/hostile/abnormality/skub
	name = "Skub"//漫画《The Perry Bible Fellowship》
	desc = "这是skub."
	health = 500
	maxHealth = 500
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	icon_living = "skub"
	portrait = "skub"
	can_breach = FALSE
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = list(10, 20, 35, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = list(10, 40, 50, 55, 60),
	)

	work_damage_upper = 7
	work_damage_lower = 6
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/pro_skub,
		/datum/ego_datum/weapon/anti_skub,
		/datum/ego_datum/armor/pro_skub,
		/datum/ego_datum/armor/anti_skub,
	)
	//gift_type =  /datum/ego_gifts/skub
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE


	observation_prompt = "你会接受Skub进入你的生活吗?"

	observation_choices = list(
		"接受Skub" = list(TRUE, "Skub真的是有史以来最棒的东西! <br>\
		脑子正常的人谁会拒绝它？"),
		"拒绝Skub" = list(TRUE, "Skub真的是个糟糕透顶的东西。<br>\
		脑子正常的人谁会接受它？"),
	)

	work_start_lines = list("Skub被公认为世界上最伟大的东西。", "Skub被普遍认为是世界上最被高估的东西。")
	late_work_lines = list("成千上万的人为了Skub而丧命。")
	work_end_lines = list("%PERSON无法停止思考Skub。")

	var/list/currently_insane = list()
	var/insanity_counter
	var/riot_cooldown
	var/riot_cooldown_time = 60 SECONDS
	var/list/skub_list = list("PRO_SKUB" = list(), "ANTI_SKUB" = list())
	var/skub_type = "skub"
	var/riot_time = 30 SECONDS

//work stuff
/mob/living/simple_animal/hostile/abnormality/skub/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat == DEAD)
			continue
		UpdateSkub(H)

/mob/living/simple_animal/hostile/abnormality/skub/WorkChance(mob/living/carbon/human/user, chance, work_type)//set the new work chances
	var/chance_mod = 0
	switch(work_type)
		if(ABNORMALITY_WORK_INSIGHT)
			if(IsProSkub(user))
				chance_mod += 25
		if(ABNORMALITY_WORK_REPRESSION)
			if(IsProSkub(user))
				chance_mod -= 35
	say(chance)
	say(chance + chance_mod)
	return chance + chance_mod

/mob/living/simple_animal/hostile/abnormality/skub/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(25))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/skub/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/skub/ZeroQliphoth(mob/living/carbon/human/user)
	..()
	riot_cooldown = world.time + riot_cooldown_time
	var/list/target_list = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat == DEAD)
			continue
		target_list += H
		UpdateSkub(H)
		if(IsProSkub(H))
			to_chat(H, span_boldwarning("你对[skub_type]的忠诚达到了狂热的程度！"))
		else
			to_chat(H, span_boldwarning("你无法停止思考自己有多么憎恨[skub_type]！"))
	sleep(3 SECONDS)
	for(var/mob/living/carbon/human/H in target_list)
		H.adjustSanityLoss(500)
		QDEL_NULL(H.ai_controller)
		if(IsProSkub(H))
			H.ai_controller = /datum/ai_controller/insane/murder/skub
			H.apply_status_effect(/datum/status_effect/panicked_type/skub)
		else
			H.ai_controller = /datum/ai_controller/insane/murder/anti_skub
			H.apply_status_effect(/datum/status_effect/panicked_type/anti_skub)

		H.InitializeAIController()
	addtimer(CALLBACK(src, PROC_REF(StopRiot)), riot_time)

/mob/living/simple_animal/hostile/abnormality/skub/proc/UpdateSkub(mob/living/carbon/human/skubber)
	if(!skubber)
		return
	if(skubber in skub_list["PRO_SKUB"])
		return
	if(skubber in skub_list["ANTI_SKUB"])
		return
	if(LAZYLEN(skub_list["PRO_SKUB"]) <= LAZYLEN(skub_list["ANTI_SKUB"]))
		skub_list["PRO_SKUB"] |= skubber
		to_chat(skubber, span_boldwarning("你变成了[skub_type]派!"))
	else
		skub_list["ANTI_SKUB"] |= skubber
		to_chat(skubber, span_boldwarning("你变成了反[skub_type]派!"))
		return

/mob/living/simple_animal/hostile/abnormality/skub/proc/IsProSkub(mob/living/skubber)
	if(!(skubber in skub_list))
		UpdateSkub(skubber)
	if(skubber in skub_list["PRO_SKUB"])
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/skub/proc/StopRiot()
	for(var/mob/living/carbon/human/H in skub_list["PRO_SKUB"])
		H.adjustSanityLoss(-500)
	for(var/mob/living/carbon/human/H in skub_list["ANTI_SKUB"])
		H.adjustSanityLoss(-500)
	datum_reference.qliphoth_change(3)

/datum/status_effect/panicked_type/skub
	icon = "murder"

/datum/ai_controller/insane/murder/skub
	lines_type = /datum/ai_behavior/say_line/skub

/datum/ai_behavior/say_line/skub
	lines = list(
		"我爱SKUB！",
		"那是我的SKUB！！！",
		"我支持skub！",
		"保护skub！",
	)

/datum/ai_controller/insane/murder/skub/CanTarget(atom/movable/thing)
	. = ..()
	var/mob/living/living_thing = thing
	if(. && istype(living_thing))
		if(ishuman(living_thing))
			var/mob/living/carbon/human/H = living_thing
			if(HAS_AI_CONTROLLER_TYPE(H, src))
				return FALSE

/datum/ai_controller/insane/murder/skub/on_Crossed(datum/source, atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(HAS_AI_CONTROLLER_TYPE(H, src))
			return
	..()

/datum/status_effect/panicked_type/anti_skub
	icon = "murder"

/datum/ai_controller/insane/murder/anti_skub
	lines_type = /datum/ai_behavior/say_line/anti_skub

/datum/ai_behavior/say_line/anti_skub
	lines = list(
		"我恨死SKUB了！",
		"把那东西给我！",
		"我要亲手毁掉那个skub！",
		"打倒skub！",
	)

/datum/ai_controller/insane/murder/anti_skub/CanTarget(atom/movable/thing)
	. = ..()
	var/mob/living/living_thing = thing
	if(. && istype(living_thing))
		if(ishuman(living_thing))
			var/mob/living/carbon/human/H = living_thing
			if(HAS_AI_CONTROLLER_TYPE(H, src))
				return FALSE

/datum/ai_controller/insane/murder/anti_skub/on_Crossed(datum/source, atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(HAS_AI_CONTROLLER_TYPE(H, src))
			return
	..()
